fn main() {
    let a = [1f64, 2f64, 3f64, 4f64];
    println!("{}", arr2str(a));
}


fn arr2str(a: &[f64]) -> String {
    let mut s = "[".to_string();
    for i in a.iter() {
        s.push_str(format!(" {}", *i).as_slice());
    }
    s.push_str(" ]");
    return s;
}
