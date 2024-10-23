use crate::FrameContent;

pub struct TableFrame {}

impl FrameContent for TableFrame {
    fn content(&self, ui: &mut egui::Ui, id: egui::Id) {}
}
