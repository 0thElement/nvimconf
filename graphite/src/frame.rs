use crate::FrameContent;

use super::selector::SelectorUi;

// This module provides types and functions for interfacing with egui on the level of each frame
// in the layout to higher level modules.
//
// Each function receives the current GUI state and draws it, or processes inputs and interprets
// them as actions which higher level modules can use to modify state.
//
// This module does not have any state.

const MARGIN: f32 = 10.;
pub const SEPERATOR_SIZE: f32 = 2.5;
const CORNER_SIZE: f32 = 7.5;

/// Render the frame into the GUI
pub fn render_frame(
    ui: &mut egui::Ui,
    rect: egui::Rect,
    id: egui::Id,
    selector: &SelectorUi,
    frame_types: &[Box<dyn FrameContent>],
    type_index: &mut usize,
) {
    let rect = rect.shrink(SEPERATOR_SIZE / 2.0);
    let selected_type = frame_types.get(*type_index);

    ui.painter()
        .rect_filled(rect, 5., ui.style().visuals.window_fill);

    let mut inner = ui.new_child(
        egui::UiBuilder::default()
            .id_salt((id, "frame"))
            .max_rect(rect.shrink(MARGIN)),
    );
    inner.shrink_clip_rect(rect);
    inner.horizontal(|ui| {
        selector.render_combo_box(ui, id, type_index);

        if let Some(panel) = selected_type {
            panel.top_bar(ui, id);
        }
    });

    if let Some(panel) = selected_type {
        panel.content(&mut inner, id);
    } else {
        selector.render(&mut inner, type_index);
    }
}

#[derive(Debug, Clone, Copy)]
pub enum Edge {
    Top,
    Bottom,
    Left,
    Right,
}

#[derive(Debug, Clone, Copy)]
pub enum Direction {
    Up,
    Down,
    Left,
    Right,
}

impl From<Edge> for Direction {
    fn from(value: Edge) -> Self {
        match value {
            Edge::Top => Self::Up,
            Edge::Bottom => Self::Down,
            Edge::Left => Self::Left,
            Edge::Right => Self::Right,
        }
    }
}

impl From<Direction> for Edge {
    fn from(value: Direction) -> Self {
        match value {
            Direction::Up => Self::Top,
            Direction::Down => Self::Bottom,
            Direction::Left => Self::Left,
            Direction::Right => Self::Right,
        }
    }
}

#[derive(Debug, Clone)]
pub struct DragResponse {
    pub edge: Edge,
    pub delta: f32,
}

/// Checks for dragging within a frame
pub fn sense_frame_drag(ui: &mut egui::Ui, rect: egui::Rect) -> Option<DragResponse> {
    let rect = rect.shrink(SEPERATOR_SIZE / 2.0);

    let up = egui::Rect {
        min: egui::pos2(rect.min.x + CORNER_SIZE, rect.min.y),
        max: egui::pos2(rect.max.x - CORNER_SIZE, rect.min.y + SEPERATOR_SIZE),
    };
    let down = egui::Rect {
        min: egui::pos2(rect.min.x + CORNER_SIZE, rect.max.y - SEPERATOR_SIZE),
        max: egui::pos2(rect.max.x - CORNER_SIZE, rect.max.y),
    };
    let left = egui::Rect {
        min: egui::pos2(rect.min.x, rect.min.y + CORNER_SIZE),
        max: egui::pos2(rect.min.x + SEPERATOR_SIZE, rect.max.y - CORNER_SIZE),
    };
    let right = egui::Rect {
        min: egui::pos2(rect.max.x - SEPERATOR_SIZE, rect.min.y + CORNER_SIZE),
        max: egui::pos2(rect.max.x, rect.max.y - CORNER_SIZE),
    };

    let sense = egui::Sense::click_and_drag().union(egui::Sense::hover());
    let up_resp = ui.allocate_rect(up, sense);
    let down_resp = ui.allocate_rect(down, sense);
    let left_resp = ui.allocate_rect(left, sense);
    let right_resp = ui.allocate_rect(right, sense);

    if up_resp.hovered() || down_resp.hovered() {
        ui.ctx().set_cursor_icon(egui::CursorIcon::ResizeVertical);
    }
    if left_resp.hovered() || right_resp.hovered() {
        ui.ctx().set_cursor_icon(egui::CursorIcon::ResizeHorizontal);
    }

    if up_resp.dragged() {
        Some(DragResponse {
            edge: Edge::Top,
            delta: up_resp.drag_delta().y,
        })
    } else if down_resp.dragged() {
        Some(DragResponse {
            edge: Edge::Bottom,
            delta: down_resp.drag_delta().y,
        })
    } else if left_resp.dragged() {
        Some(DragResponse {
            edge: Edge::Left,
            delta: left_resp.drag_delta().x,
        })
    } else if right_resp.dragged() {
        Some(DragResponse {
            edge: Edge::Right,
            delta: right_resp.drag_delta().x,
        })
    } else {
        None
    }
}
