fn suma(a: i32, b: i32) -> i32 {
    return a + b;
}

fn compare(x: i32, y: i32) -> bool {
    if x > y {
        return true;
    } else {
        return false;
    }
}

fn main() {
    let a: i32 = 10;
    let b: f64 = 20.5;
    let c: bool = true;
    let d: char = 'd';
    let e: str = "Hola Mundo!!!"; //  comentario random para probar el parser y lexer

    let sum = a + 5;
    let diff = b - 3.2;
    let prod = a * 2;
    let quot = b / 2.5;
    let module = a % 3;

    // Comparisons
    if a > 5 && b < 30.0 {
        return true;
    } else {
        return false;
    };
}
