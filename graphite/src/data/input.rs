#![allow(unused)]

pub type InputData = Vec<InputDataRow>;

pub struct InputDataRow {
    pub mem_name: String,
    pub mem_type: String,
    pub mem_position: String,
    pub dwg_name: String,
    pub shindan: String,
}

pub fn get_test_data() -> InputData {
    todo!()
}
