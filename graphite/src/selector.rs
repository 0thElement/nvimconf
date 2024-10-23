use egui::text::LayoutJob;

#[derive(Clone)]
pub struct FrameTypeInfo {
    pub icon: &'static str,
    pub name: &'static str,
    pub index: usize,
}

pub struct SelectorCategory {
    pub name: &'static str,
    pub color: egui::Color32,
    pub frames: Vec<FrameTypeInfo>,
}

impl FrameTypeInfo {
    pub fn new(name: &'static str, icon: &'static str, index: usize) -> Self {
        Self { name, icon, index }
    }
}

pub struct SelectorUi {
    pub categories: Vec<SelectorCategory>,
}

impl SelectorUi {
    pub fn get_frame_info(&self, index: usize) -> Option<FrameTypeInfo> {
        for cat in self.categories.iter() {
            for frame in cat.frames.iter() {
                if frame.index == index {
                    return Some(frame.clone());
                }
            }
        }

        None
    }

    pub fn render(&self, ui: &mut egui::Ui, type_index: &mut usize) {
        let rect = ui.available_rect_before_wrap();
        const SHRINK_AMOUNT: f32 = 0.07;
        let offset = egui::vec2(rect.width() * SHRINK_AMOUNT, rect.height() * SHRINK_AMOUNT);
        let rect = egui::Rect {
            min: rect.min + offset,
            max: rect.max - offset,
        };

        let mut inner = ui.new_child(egui::UiBuilder::new().max_rect(rect));
        inner.vertical(|ui| {
            ui.heading("Open menu:");
            let full_size = ui.available_rect_before_wrap();
            let full_height = full_size.height();
            let scaling = f32::clamp(full_height / 200.0, 0.75, 1.2);
            let item_width = scaling * 150.0;
            let item_per_row = (full_size.width() / item_width).floor() as usize;
            let item_per_row = item_per_row.max(2);
            let item_width = full_size.width() / item_per_row as f32;
            let font_scaling = f32::min(f32::clamp(item_width / 100.0, 0.75, 1.2), scaling);
            ui.allocate_space(egui::vec2(0.0, scaling * 5.0));
            egui::ScrollArea::both().show(ui, |ui| {
                self.render_grid(
                    ui,
                    type_index,
                    scaling * 12.0,
                    scaling * 15.0,
                    |ui, cat, cell, type_index| {
                        let mut layout = LayoutJob {
                            break_on_newline: true,
                            justify: true,
                            ..Default::default()
                        };
                        layout.append(
                            cell.icon,
                            0.0,
                            egui::TextFormat {
                                font_id: egui::FontId {
                                    size: font_scaling * 12.0,
                                    family: egui::FontFamily::Proportional,
                                },
                                valign: egui::Align::Center,
                                color: cat.color,
                                ..Default::default()
                            },
                        );
                        layout.append(
                            &format!(" {}", cell.name),
                            0.0,
                            egui::TextFormat {
                                font_id: egui::FontId {
                                    size: font_scaling * 12.0,
                                    family: egui::FontFamily::Proportional,
                                },
                                valign: egui::Align::Center,
                                color: if *type_index == cell.index {
                                    ui.style().visuals.selection.stroke.color
                                } else {
                                    egui::Color32::GRAY
                                },
                                ..Default::default()
                            },
                        );
                        ui.selectable_value(type_index, cell.index, layout);
                    },
                )
            });
        });
    }

    pub fn render_combo_box(&self, ui: &mut egui::Ui, id: egui::Id, type_index: &mut usize) {
        egui::ComboBox::from_id_salt((id, "Panel selector"))
            .selected_text(
                self.get_frame_info(*type_index)
                    .map(|x| format!("{} {}", x.icon, x.name))
                    .unwrap_or("".to_string()),
            )
            .width(25.0)
            .show_ui(ui, |ui| {
                self.render_grid(ui, type_index, 12.0, 15.0, |ui, cat, cell, type_index| {
                    let mut layout = LayoutJob {
                        break_on_newline: true,
                        justify: true,
                        ..Default::default()
                    };
                    layout.append(
                        cell.icon,
                        0.0,
                        egui::TextFormat {
                            font_id: egui::FontId {
                                size: 12.0,
                                family: egui::FontFamily::Proportional,
                            },
                            valign: egui::Align::Center,
                            color: cat.color,
                            ..Default::default()
                        },
                    );
                    layout.append(
                        &format!(" {}", cell.name),
                        0.0,
                        egui::TextFormat {
                            font_id: egui::FontId {
                                size: 12.0,
                                family: egui::FontFamily::Proportional,
                            },
                            valign: egui::Align::Center,
                            color: if *type_index == cell.index {
                                ui.style().visuals.selection.stroke.color
                            } else {
                                egui::Color32::GRAY
                            },
                            ..Default::default()
                        },
                    );
                    ui.selectable_value(type_index, cell.index, layout);
                });
            });
    }

    fn render_grid(
        &self,
        ui: &mut egui::Ui,
        type_index: &mut usize,
        label_size: f32,
        empty_cell_height: f32,
        cell_fn: impl Fn(&mut egui::Ui, &SelectorCategory, &FrameTypeInfo, &mut usize),
    ) {
        if self.categories.is_empty() {
            return;
        }

        let max_cat_len = self
            .categories
            .iter()
            .max_by_key(|x| x.frames.len())
            .expect("This should not be None if categories is not empty")
            .frames
            .len();

        egui::Grid::new("selector").show(ui, |ui| {
            for cat in self.categories.iter() {
                ui.label(
                    egui::RichText::new(cat.name)
                        .color(ui.style().visuals.widgets.inactive.fg_stroke.color)
                        .size(label_size),
                );
            }
            ui.end_row();

            for i in 0..max_cat_len {
                for cat in self.categories.iter() {
                    if i < cat.frames.len() {
                        cell_fn(ui, cat, &cat.frames[i], type_index);
                    } else {
                        ui.allocate_space(egui::vec2(0.0, empty_cell_height));
                    }
                }
                ui.end_row();
            }
        });
    }
}
