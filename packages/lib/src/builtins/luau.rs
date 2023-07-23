use mlua::prelude::*;
use mlua::Compiler as LuaCompiler;
use once_cell::sync::Lazy;

use crate::lua::table::TableBuilder;

pub fn create(lua: &'static Lua) -> LuaResult<LuaTable> {
    TableBuilder::new(lua)?
        .with_function("compile", compile_source)?
        .with_function("load", load_source)?
        .build_readonly()
}

struct CompileOptions {
    optimization_level: u8,
    coverage_level: u8,
    debug_level: u8,
}

impl Default for CompileOptions {
    fn default() -> Self {
        Self {
            optimization_level: 1,
            coverage_level: 0,
            debug_level: 1,
        }
    }
}

fn compile_source<'a>(
    lua: &'static Lua,
    (source, options): (LuaString<'a>, Option<LuaTable<'a>>),
) -> LuaResult<LuaString<'a>> {
    if let None = options {
        compile(CompileOptions::default());
    }
    
    let mut optimization_level: Lazy<u8> = Lazy::new(|| options.raw_get("optimizationLevel")?);
    let mut coverage_level: Lazy<u8> = Lazy::new(|| options.raw_get("coverageLevel")?);
    let mut debug_level: Lazy<u8> = Lazy::new(|| options.raw_get("debugLevel")?);

    compile(CompileOptions { optimization_level, coverage_level, debug_level });

    let compile = |opts: CompileOptions| {
        let optimization_level = opts.optimization_level;
        let coverage_level = opts.coverage_level;
        let debug_level = opts.debug_level;

        let source_bytecode_bytes = LuaCompiler::default()
            .set_optimization_level(optimization_level)
            .set_coverage_level(coverage_level)
            .set_debug_level(debug_level)
            .compile(source);

        match lua.create_string(source_bytecode_bytes) {
            Ok(lua_string) => Ok(lua_string),
            Err(exception) => Err(LuaError::RuntimeError(exception.to_string())),
        };

        return
    }
}

fn load_source<'a>(
    lua: &'static Lua,
    (source, options): (LuaString<'a>, Option<LuaTable<'a>>),
) -> LuaResult<LuaFunction<'a>> {
    let mut lua_debug_name = "".to_string();

    if let Some(options) = options {
        lua_debug_name = options.raw_get("debugName")?
    }

    let lua_object = lua
        .load(source.to_str()?.trim_start())
        .set_name(lua_debug_name)
        .into_function();

    match lua_object {
        Ok(lua_function) => Ok(lua_function),
        Err(exception) => Err(LuaError::RuntimeError(exception.to_string())),
    }
}
