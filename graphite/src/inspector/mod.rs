use crate::FrameContent;

pub struct InspectorFrame {}

impl FrameContent for InspectorFrame {
    fn content(&self, ui: &mut egui::Ui, id: egui::Id) {}
}
