use std::mem::transmute;

use wasm_minimal_protocol::*;
use smolprng::*;
initiate_protocol!();

fn u32_to_bytes(value:u32) -> [u8;4]
{
    let out: [u8;4] = unsafe {transmute(value.to_be())};
    
    return out
}

fn bytes_to_u32(arr: &[u8]) -> u32 {
    let mut out = 0;
    for &s in arr {      
        out = out*256+u32::from(s)
    } 
    return out 
}

#[wasm_func]
pub fn shuffle(arg: &[u8], seed:&[u8]) -> Vec<u8> {
    let mut items:Vec<u8> = arg.into();
    let mut output: Vec<u8> = Vec::new();
    let seed = bytes_to_u32(seed); 
    let mut prng = PRNG{generator: StepGenerator8::from(seed)};
    while items.len() > 0 {
        let index = usize::from(prng.gen_u8())%items.len();
        output.push(items[index]);
        items.remove(index);
    }
    let mut newseed: Vec<u8> = u32_to_bytes(prng.gen_u32()).into(); 
    newseed.append(&mut output);
    return newseed.into()
}




