#![allow(unused)]

use std::collections::HashSet;

use super::input::InputData;
use anyhow::anyhow;
use egui::Pos2;

pub struct Data {
    pub dwgs: Vec<Dwg>,
    pub mems: Vec<Mem>,
    pub mem_groups: Vec<MemGroup>,
    pub connections: Vec<Connection>,
}

pub struct Dwg {
    pub name: String,
    pub note: String,
    pub in_mem_groups: Vec<usize>,
    pub out_mem_groups: Vec<usize>,
}

pub struct MemGroup {
    pub mems: Vec<usize>,
}

pub struct Mem {
    pub name: String,
    pub note: String,
    pub mem_type: MemType,
}

pub enum MemType {
    Ram,
    Calib,
    BackupRam,
}

impl MemType {
    fn from(x: &str) -> Result<Self, anyhow::Error> {
        if x == "RAM" {
            Ok(Self::Ram)
        } else if x == "CALIB" {
            Ok(Self::Calib)
        } else {
            Err(anyhow!(format!("Invalid memory type: {x}")))
        }
    }
}

pub struct Connection {
    pub from: GroupLocation,
    pub to: GroupLocation,
}

pub struct GroupLocation {
    pub dwg_index: usize,
    pub mem_group_index: usize,
}

pub fn convert_from_raw(data: InputData) -> Result<Data, anyhow::Error> {
    let mems: Vec<Mem> = data
        .iter()
        .map(|row| {
            MemType::from(&row.mem_type).map(|mem_type| Mem {
                name: row.mem_name.clone(),
                note: "".into(),
                mem_type,
            })
        })
        .collect::<Result<Vec<Mem>, anyhow::Error>>()?;

    let mut dwgs = data
        .iter()
        .map(|row| row.dwg_name.clone())
        .collect::<HashSet<_>>()
        .into_iter()
        .map(|dwg_name| Dwg {
            name: dwg_name,
            note: "".into(),
            in_mem_groups: vec![],
            out_mem_groups: vec![],
            pos: Default::default(),
        })
        .collect::<Vec<Dwg>>();

    todo!()
}
