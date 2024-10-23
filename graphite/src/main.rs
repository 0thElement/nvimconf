mod bars;
mod frame;
mod graph;
mod inspector;
mod layout;
mod selector;
mod table;
mod theme;
mod data;

use frame::{render_frame, sense_frame_drag, Edge};
use layout::{get_interval, Frame, Layout};
use selector::{FrameTypeInfo, SelectorCategory, SelectorUi};

use std::{
    hash::Hash,
    sync::{Arc, Mutex},
};

/// Container of the entire GUI system.
pub struct Editor {
    id: egui::Id,
    frames: Vec<Box<dyn FrameContent>>,
    selector: SelectorUi,
    layouts: Arc<Mutex<Layouts>>,
}

/// Draws the content of a frame.
///
/// A GUI layout is divided into frames, and all types implementing this trait can be drawn into a
/// frame.
pub trait FrameContent {
    #[allow(unused)]
    fn content(&self, ui: &mut egui::Ui, id: egui::Id) {}

    #[allow(unused)]
    fn top_bar(&self, ui: &mut egui::Ui, id: egui::Id) {}
}

/// Contains data of different layouts which can be saved and loaded on application exit and startup.
#[derive(serde::Deserialize, serde::Serialize)]
struct Layouts {
    layouts: Vec<Layout>,
    selected: usize,
}

pub const UNKNOWN_FRAME_TYPE: usize = 9999;

impl Editor {
    pub fn new(id_source: impl Hash) -> Self {
        let frames: Vec<Box<dyn FrameContent>> = vec![
            Box::new(graph::GraphFrame {}),
            Box::new(table::TableFrame {}),
            Box::new(inspector::InspectorFrame {}),
        ];

        let selector = SelectorUi {
            categories: vec![SelectorCategory {
                name: "Editing",
                color: theme::RED,
                frames: vec![
                    FrameTypeInfo::new("Graph", egui_phosphor::fill::GRAPH, 0),
                    FrameTypeInfo::new("Table", egui_phosphor::fill::TABLE, 1),
                    FrameTypeInfo::new("Inspector", egui_phosphor::fill::FADERS_HORIZONTAL, 2),
                ],
            }],
        };

        let default_layouts = vec![Layout::new(
            "Default",
            vec![
                Frame::new(0, egui::Rect::from_x_y_ranges(0.0..=0.75, 0.0..=1.0)),
                Frame::new(1, egui::Rect::from_x_y_ranges(0.75..=1.0, 0.0..=0.66)),
                Frame::new(2, egui::Rect::from_x_y_ranges(0.75..=1.0, 0.66..=1.0)),
            ],
        )];
        let layouts = Layouts {
            layouts: default_layouts,
            selected: 0,
        };

        let layouts = Arc::new(Mutex::new(layouts));

        Self {
            id: egui::Id::new(id_source),
            frames,
            selector,
            layouts,
        }
    }

    pub fn ui(&mut self, ctx: &egui::Context) {
        egui::TopBottomPanel::top("top_bar")
            .exact_height(30.0)
            .resizable(false)
            .show_separator_line(false)
            .show(ctx, bars::top_bars);

        egui::TopBottomPanel::bottom("bottom_bar")
            .exact_height(30.0)
            .resizable(false)
            .show_separator_line(false)
            .show(ctx, bars::bottom_bars);

        egui::CentralPanel::default()
            .frame(egui::Frame::default())
            .show(ctx, |ui| {
                let layout_data: Option<Arc<Mutex<Layouts>>> =
                    ui.memory_mut(|mem| mem.data.get_persisted(self.id));
                if let Some(persisted) = layout_data {
                    self.layouts = persisted;
                }

                let mut layouts = self.layouts.lock().unwrap();
                let selected = layouts.selected.clamp(0, layouts.layouts.len() - 1);
                let current_layout = &mut layouts.layouts[selected];
                render_layout(ui, current_layout, &self.selector, &self.frames);

                ui.memory_mut(|mem| mem.data.insert_persisted(self.id, self.layouts.clone()));
            });
    }
}

fn render_layout(
    ui: &mut egui::Ui,
    layout: &mut Layout,
    selector: &SelectorUi,
    types: &[Box<dyn FrameContent>],
) {
    let full = ui.available_rect_before_wrap();
    ui.painter().rect_filled(full, 0., egui::Color32::BLACK);
    for frame in layout.content.iter_mut() {
        let real_rect = relative_to_real_rect(frame.rect, full);

        render_frame(
            ui,
            real_rect,
            frame.id,
            selector,
            types,
            &mut frame.frame_type,
        );
    }

    for frame in layout.content.iter() {
        let real_rect = relative_to_real_rect(frame.rect, full);

        if let Some(resp) = sense_frame_drag(ui, real_rect) {
            let drag_delta = resp.delta
                / match resp.edge {
                    Edge::Top | Edge::Bottom => full.height(),
                    Edge::Left | Edge::Right => full.width(),
                };
            layout.drag(get_interval(&frame.rect, resp.edge), drag_delta);
            return;
        }
    }
}

fn lerp(from: f32, to: f32, t: f32) -> f32 {
    from + (to - from) * t
}

fn relative_to_real_rect(rect: egui::Rect, full: egui::Rect) -> egui::Rect {
    egui::Rect {
        min: egui::pos2(
            lerp(full.min.x, full.max.x, rect.min.x),
            lerp(full.min.y, full.max.y, rect.min.y),
        ),
        max: egui::pos2(
            lerp(full.min.x, full.max.x, rect.max.x),
            lerp(full.min.y, full.max.y, rect.max.y),
        ),
    }
}

pub fn render(editor: &mut Editor, ctx: &egui::Context) {
    editor.ui(ctx);
}

impl eframe::App for Editor {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        render(self, ctx);
    }
}

fn main() {
    simple_logger::SimpleLogger::new()
        .with_level(log::LevelFilter::Trace)
        .with_module_level("wgpu", log::LevelFilter::Warn)
        .with_module_level("naga", log::LevelFilter::Info)
        .init()
        .unwrap();
    log_panics::init();

    let options = eframe::NativeOptions {
        ..Default::default()
    };

    match eframe::run_native(
        "My egui App",
        options,
        Box::new(|cc| {
            let mut fonts = egui::FontDefinitions::default();
            egui_phosphor::add_to_fonts(&mut fonts, egui_phosphor::Variant::Fill);
            cc.egui_ctx.set_fonts(fonts);
            Ok(Box::new(Editor::new("main ui")))
        }),
    ) {
        Ok(_) => {}
        Err(e) => log::error!("{e}"),
    }
}
