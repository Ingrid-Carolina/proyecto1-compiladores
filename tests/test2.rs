fn factorial(n: i32) -> i32 {
    if n < 2 {
        return 1;
    } else {
        return factorial(n);
    }
}

fn main() {
    let resultado: i32 = factorial(5);
    let x: i32 = 10;
    let y: i32 = 20;
    let suma = x + y;
}