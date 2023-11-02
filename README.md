# KTRO Compiler 🚀

Welcome to the KTRO compiler, a powerful tool for creating and running programs in the KTRO programming language. KTRO is a simple, efficient, and low-level language that gives you direct memory access, and our compiler is proudly made completely in assembly.

## Table of Contents
- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Compiling KTRO Files](#compiling-ktro-files)
- [Language Features](#language-features)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Introduction
KTRO is a straightforward language designed for low-level system programming. You can define functions, work with variables, and even format and write output to the console. The language prioritizes simplicity and performance, making it suitable for various system-level tasks.

## Getting Started
### Installation
To get started with KTRO, you'll need to download and install the KTRO compiler. Unfortunately, the download link is not yet implemented. Stay tuned for updates on this feature!

### Compiling KTRO Files
Once you have the KTRO compiler installed (when available), you can compile KTRO source files with the following command:

```shell
ktro [file]
```

Replace `[file]` with the path to your KTRO source file.

## Language Features
KTRO comes with a few fundamental language features that make it ideal for low-level programming:

- **Function Definition:**
  Functions in KTRO are defined using the `fn` keyword. Here's an example:

  ```ktro
  fn foo(x: i32) !i32 {
       return bar()
  }
  ```

- **Variables:**
  KTRO allows you to work with both immutable (`imm`) and mutable (`mut`) variables. Here are some variable declarations:

  ```ktro
  imm i32 x = 3; # imm means immutable
  mut i32 y = 5;
  ```

- **Console Output:**
  You can format and write to the console using the `fmw` and `fmr` functions. For example:

  ```ktro
  fmw("Hello world!") # format write
  mut str name = fmr("Enter your name: ")
  ```

- **Direct Memory Access:**
  KTRO grants you direct memory access, enabling you to work at a low level when necessary.

## Examples
Here are some simple examples to showcase KTRO's capabilities:

```ktro
fn add(x: i32, y: i32) !i32 {
    return x + y
}

mut i32 result = add(5, 3)
fmw("The result is: ")
fmw(result)
```

```ktro
imm i32 n = 10
mut i32 sum = 0

fn calculate_sum() {
    for imm i32 i = 1; i <= n; i = i + 1 {
        sum = sum + i
    }
}

calculate_sum()
fmw("The sum of the first 10 natural numbers is: ")
fmw(sum)
```

## Contributing
We welcome contributions from the KTRO community. If you have ideas for improvements, find bugs, or want to contribute to the development of the KTRO compiler, please feel free to get involved. You can find our contribution guidelines in our repository (link to be provided when available).

## License
KTRO is open-source software and is distributed under the MIT License. See the [LICENSE](LICENSE) file for details.

Thank you for choosing KTRO, and we hope it serves you well in your low-level programming adventures! 🚀👾
