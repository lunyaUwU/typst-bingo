use wasm_minimal_protocol::*;
use smolprng::*;
initiate_protocol!();

#[wasm_func]
pub fn shuffle(arg: &[u8], seed:&[u8]) -> Vec<u8> {
    let mut items:Vec<u8> = arg.into();
    let mut output: Vec<u8> = Vec::new();
    let seed_arr = seed;
    let mut seed:u32 = 0;
    for &s in seed_arr {      
        seed = seed*256+u32::from(s)
    } 
    let mut prng = PRNG{generator: StepGenerator8::from(seed)};
    while items.len() > 0 {
        let index = usize::from(prng.gen_u8())%items.len();
        output.push(items[index]);
        items.remove(index);
    }
    return output.into()
}


