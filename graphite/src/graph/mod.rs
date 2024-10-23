use crate::FrameContent;

pub struct GraphFrame {}

impl FrameContent for GraphFrame {
    fn content(&self, ui: &mut egui::Ui, id: egui::Id) {}
}
