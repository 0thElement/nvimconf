use super::frame::{Direction, Edge};

// This modules contains types that stores layout states and methods to modify them.
//
// This module does not interoperate with egui and is only concerned with abstracting state.

/// A layout, which is mostly just a list of frames and some helper info.
#[derive(serde::Serialize, serde::Deserialize)]
pub struct Layout {
    /// The unique id of this layout for idenfitication only.
    pub id: egui::Id,
    /// The display name of this layout.
    pub name: String,
    /// The frames that this layout is composed of.
    pub content: Vec<Frame>,
}

/// A frame within the layout.
#[derive(serde::Serialize, serde::Deserialize, Clone)]
pub struct Frame {
    /// An index into the global frame type registers.
    pub frame_type: usize,
    /// The [`egui::Rect`] boundary of this frame.
    pub rect: egui::Rect,
    /// The unique id of this frame which can be passed to frame drawer so it can retrieve and
    /// store state through gui more easily
    pub id: egui::Id,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Axis {
    Horizontal,
    Vertical,
}

impl Axis {
    pub fn other(self) -> Axis {
        match self {
            Axis::Horizontal => Axis::Vertical,
            Axis::Vertical => Axis::Horizontal,
        }
    }
}
impl From<Direction> for Axis {
    fn from(value: Direction) -> Self {
        match value {
            Direction::Up | Direction::Down => Self::Vertical,
            Direction::Left | Direction::Right => Self::Horizontal,
        }
    }
}

const EPSILON: f32 = 0.001;
pub const MIN_SIZE: f32 = 0.05;

/// A line with a starting and ending point.
#[derive(Debug, Clone, Copy)]
pub struct Interval {
    /// The axis this line follows.
    pub axis: Axis,
    /// The starting position of the line along the [`Interval::axis`].
    pub axis_from: f32,
    /// The ending position of the line along the [`Interval::axis`].
    pub axis_to: f32,
    /// The position in the direction perpendicular to [`Interval::axis`],
    pub perpendicular_pos: f32,
}

impl Interval {
    /// Checks if an interval intersects another interval.
    pub fn intersects(&self, other: &Interval) -> bool {
        let same_pos = f32::abs(self.perpendicular_pos - other.perpendicular_pos) < EPSILON;
        let same_axis = self.axis == other.axis;
        let interval_intersect = self.axis_from < other.axis_to && self.axis_to > other.axis_from;
        same_axis && same_pos && interval_intersect
    }
}

impl Layout {
    pub fn new(name: impl Into<String>, content: Vec<Frame>) -> Self {
        Self {
            id: egui::Id::new(rand::random::<u64>()),
            name: name.into(),
            content,
        }
    }

    /// Modifies the layout by dragging an interval.
    pub fn drag(&mut self, drag_interval: Interval, delta: f32) {
        // Don't drag edges of the screen
        if drag_interval.perpendicular_pos <= EPSILON
            || drag_interval.perpendicular_pos >= 1. - EPSILON
        {
            return;
        }

        // Find smallest draggable interval
        // +---+ +---+
        // |   | |   |  -  in this case, edge of the frame itself is smallest draggable interval
        // +-x-+ +---+
        // <--->
        //
        // +---+ +---+
        // |   | |   |  -  in this case, the interval is expanded otherwise dragging the original
        // +-x-+ +---+     frame will cause it to clip into the frame below
        // <--------->
        // +---------+
        // |         |
        // +---------+

        let mut drag_interval = drag_interval;
        let mut stop = false;

        // Check in multiple passes since one frame can indirectly influence another.
        while !stop {
            let mut min_axis_pos = f32::MAX;
            let mut max_axis_pos = f32::MIN;
            for frame in self.content.iter() {
                if let Some(edge) = intersects_interval(&frame.rect, &drag_interval) {
                    let interval = get_interval(&frame.rect, edge);
                    min_axis_pos = min_axis_pos.min(interval.axis_from);
                    max_axis_pos = max_axis_pos.max(interval.axis_to);
                }
            }

            stop = min_axis_pos == drag_interval.axis_from && max_axis_pos == drag_interval.axis_to;
            drag_interval = Interval {
                axis: drag_interval.axis,
                axis_from: min_axis_pos,
                axis_to: max_axis_pos,
                perpendicular_pos: drag_interval.perpendicular_pos,
            }
        }

        // Limit the dragging interval to screen border
        let mut limit_low: f32 = 0. + MIN_SIZE;
        let mut limit_hi: f32 = 1. - MIN_SIZE;

        // Limit dragging interval by other edges
        for frame in self.content.iter() {
            let (frame_from, frame_to) = range_along_axis(&frame.rect, drag_interval.axis);
            let intersects = drag_interval.axis_from <= frame_to - EPSILON
                && drag_interval.axis_to >= frame_from + EPSILON;

            if intersects {
                let (frame_from, frame_to) =
                    range_along_axis(&frame.rect, drag_interval.axis.other());
                if frame_from < drag_interval.perpendicular_pos {
                    limit_low = limit_low.max(frame_from + MIN_SIZE);
                }

                if frame_to < drag_interval.perpendicular_pos {
                    limit_low = limit_low.max(frame_to);
                }

                if frame_from > drag_interval.perpendicular_pos {
                    limit_hi = limit_hi.min(frame_from);
                }

                if frame_to > drag_interval.perpendicular_pos {
                    limit_hi = limit_hi.min(frame_to - MIN_SIZE);
                }
            }
        }

        let delta = f32::clamp(drag_interval.perpendicular_pos + delta, limit_low, limit_hi)
            - drag_interval.perpendicular_pos;

        // Set interval
        for frame in self.content.iter_mut() {
            let value = drag_interval.perpendicular_pos + delta;
            if let Some(edge) = intersects_interval(&frame.rect, &drag_interval) {
                frame.modify_size(edge, value);
            }
        }
    }
}

impl Frame {
    pub fn new(frame_type: usize, rect: egui::Rect) -> Self {
        Self {
            id: egui::Id::new(rand::random::<u64>()),
            frame_type,
            rect,
        }
    }

    pub fn modify_size(&mut self, edge: Edge, value: f32) {
        match edge {
            Edge::Top => self.rect.min.y = value,
            Edge::Bottom => self.rect.max.y = value,
            Edge::Left => self.rect.min.x = value,
            Edge::Right => self.rect.max.x = value,
        }
    }
}

pub fn up_interval(rect: &egui::Rect) -> Interval {
    Interval {
        axis: Axis::Horizontal,
        axis_from: rect.min.x,
        axis_to: rect.max.x,
        perpendicular_pos: rect.min.y,
    }
}

pub fn down_interval(rect: &egui::Rect) -> Interval {
    Interval {
        axis: Axis::Horizontal,
        axis_from: rect.min.x,
        axis_to: rect.max.x,
        perpendicular_pos: rect.max.y,
    }
}

pub fn left_interval(rect: &egui::Rect) -> Interval {
    Interval {
        axis: Axis::Vertical,
        axis_from: rect.min.y,
        axis_to: rect.max.y,
        perpendicular_pos: rect.min.x,
    }
}

pub fn right_interval(rect: &egui::Rect) -> Interval {
    Interval {
        axis: Axis::Vertical,
        axis_from: rect.min.y,
        axis_to: rect.max.y,
        perpendicular_pos: rect.max.x,
    }
}

pub fn get_interval(rect: &egui::Rect, edge: Edge) -> Interval {
    match edge {
        Edge::Top => up_interval(rect),
        Edge::Bottom => down_interval(rect),
        Edge::Left => left_interval(rect),
        Edge::Right => right_interval(rect),
    }
}

pub fn intersects_interval(rect: &egui::Rect, interval: &Interval) -> Option<Edge> {
    if up_interval(rect).intersects(interval) {
        Some(Edge::Top)
    } else if down_interval(rect).intersects(interval) {
        Some(Edge::Bottom)
    } else if left_interval(rect).intersects(interval) {
        Some(Edge::Left)
    } else if right_interval(rect).intersects(interval) {
        Some(Edge::Right)
    } else {
        None
    }
}

pub fn range_along_axis(rect: &egui::Rect, axis: Axis) -> (f32, f32) {
    let self_range_from = match axis {
        Axis::Horizontal => rect.min.x,
        Axis::Vertical => rect.min.y,
    };

    let self_range_to = match axis {
        Axis::Horizontal => rect.max.x,
        Axis::Vertical => rect.max.y,
    };

    (self_range_from, self_range_to)
}
