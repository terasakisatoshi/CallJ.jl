//extern crate libc;

//use libc::c_char;
//use libc::c_int;

//use std::ffi::CString;


#[link(name="callj", kind="dylib")]
extern{
    fn greet();
}

#[link(name="jlinit", kind="dylib")]
extern{
    //fn jlinit(argc: c_int, argv: *const *const c_char);
    fn jlinit();

}

fn main() {
    // create a vector of zero terminated strings
    //let args = std::env::args().map(|arg| CString::new(arg).unwrap() ).collect::<Vec<CString>>();
    // convert the strings to raw pointers
    //let c_args = args.iter().map(|arg| arg.as_ptr()).collect::<Vec<*const c_char>>();

    //unsafe {jlinit(c_args.len() as c_int, c_args.as_ptr()); greet();};
    unsafe {jlinit(); greet();};

}