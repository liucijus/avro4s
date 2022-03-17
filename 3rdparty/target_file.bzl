# Do not edit. bazel-deps autogenerates this file from.
_JAVA_LIBRARY_TEMPLATE = """
java_library(
  name = "{name}",
  exports = [
      {exports}
  ],
  runtime_deps = [
    {runtime_deps}
  ],
  visibility = [
      "{visibility}"
  ]
)\n"""

_SCALA_IMPORT_TEMPLATE = """
scala_import(
    name = "{name}",
    exports = [
        {exports}
    ],
    jars = [
        {jars}
    ],
    runtime_deps = [
        {runtime_deps}
    ],
    visibility = [
        "{visibility}"
    ]
)
"""

_SCALA_LIBRARY_TEMPLATE = """
scala_library(
    name = "{name}",
    exports = [
        {exports}
    ],
    runtime_deps = [
        {runtime_deps}
    ],
    visibility = [
        "{visibility}"
    ]
)
"""

def _build_external_workspace_from_opts_impl(ctx):
    build_header = ctx.attr.build_header
    separator = ctx.attr.separator
    target_configs = ctx.attr.target_configs

    result_dict = {}
    for key, cfg in target_configs.items():
        build_file_to_target_name = key.split(":")
        build_file = build_file_to_target_name[0]
        target_name = build_file_to_target_name[1]
        if build_file not in result_dict:
            result_dict[build_file] = []
        result_dict[build_file].append(cfg)

    for key, file_entries in result_dict.items():
        build_file_contents = build_header + "\n\n"
        for build_target in file_entries:
            entry_map = {}
            for entry in build_target:
                elements = entry.split(separator)
                build_entry_key = elements[0]
                if elements[1] == "L":
                    entry_map[build_entry_key] = [e for e in elements[2::] if len(e) > 0]
                elif elements[1] == "B":
                    entry_map[build_entry_key] = (elements[2] == "true" or elements[2] == "True")
                else:
                    entry_map[build_entry_key] = elements[2]

            exports_str = ""
            for e in entry_map.get("exports", []):
                exports_str += "\"" + e + "\",\n"

            jars_str = ""
            for e in entry_map.get("jars", []):
                jars_str += "\"" + e + "\",\n"

            runtime_deps_str = ""
            for e in entry_map.get("runtimeDeps", []):
                runtime_deps_str += "\"" + e + "\",\n"

            name = entry_map["name"].split(":")[1]
            if entry_map["lang"] == "java":
                build_file_contents += _JAVA_LIBRARY_TEMPLATE.format(name = name, exports = exports_str, runtime_deps = runtime_deps_str, visibility = entry_map["visibility"])
            elif entry_map["lang"].startswith("scala") and entry_map["kind"] == "import":
                build_file_contents += _SCALA_IMPORT_TEMPLATE.format(name = name, exports = exports_str, jars = jars_str, runtime_deps = runtime_deps_str, visibility = entry_map["visibility"])
            elif entry_map["lang"].startswith("scala") and entry_map["kind"] == "library":
                build_file_contents += _SCALA_LIBRARY_TEMPLATE.format(name = name, exports = exports_str, runtime_deps = runtime_deps_str, visibility = entry_map["visibility"])
            else:
                print(entry_map)

        ctx.file(ctx.path(key + "/BUILD"), build_file_contents, False)
    return None

build_external_workspace_from_opts = repository_rule(
    attrs = {
        "target_configs": attr.string_list_dict(mandatory = True),
        "separator": attr.string(mandatory = True),
        "build_header": attr.string(mandatory = True),
    },
    implementation = _build_external_workspace_from_opts_impl,
)

def build_header():
    return """load("@io_bazel_rules_scala//scala:scala_import.bzl", "scala_import")
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")"""

def list_target_data_separator():
    return "|||"

def list_target_data():
    return {
        "3rdparty/jvm/com/fasterxml/jackson/core:jackson_annotations": ["lang||||||java", "name||||||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_annotations", "visibility||||||//3rdparty/jvm:__subpackages__", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/com/fasterxml/jackson/core/jackson_annotations", "runtimeDeps|||L|||", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/com/fasterxml/jackson/core:jackson_core": ["lang||||||java", "name||||||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_core", "visibility||||||//3rdparty/jvm:__subpackages__", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/com/fasterxml/jackson/core/jackson_core", "runtimeDeps|||L|||", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind": ["lang||||||java", "name||||||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind", "visibility||||||//3rdparty/jvm:__subpackages__", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/com/fasterxml/jackson/core/jackson_databind", "runtimeDeps|||L|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_annotations|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_core", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/com/propensive:mercator_2_12": ["lang||||||java", "name||||||//3rdparty/jvm/com/propensive:mercator_2_12", "visibility||||||//visibility:public", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/com/propensive/mercator_2_12", "runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/com/thoughtworks/paranamer:paranamer": ["lang||||||java", "name||||||//3rdparty/jvm/com/thoughtworks/paranamer:paranamer", "visibility||||||//3rdparty/jvm:__subpackages__", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/com/thoughtworks/paranamer/paranamer", "runtimeDeps|||L|||", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/org/apache/avro:avro": ["lang||||||java", "name||||||//3rdparty/jvm/org/apache/avro:avro", "visibility||||||//visibility:public", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/org/apache/avro/avro", "runtimeDeps|||L|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_core|||//3rdparty/jvm/com/fasterxml/jackson/core:jackson_databind|||//3rdparty/jvm/org/apache/commons:commons_compress|||//3rdparty/jvm/org/slf4j:slf4j_api", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/org/apache/commons:commons_compress": ["lang||||||java", "name||||||//3rdparty/jvm/org/apache/commons:commons_compress", "visibility||||||//3rdparty/jvm:__subpackages__", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/org/apache/commons/commons_compress", "runtimeDeps|||L|||", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/org/json4s:json4s_scalap_2_12": ["lang||||||java", "name||||||//3rdparty/jvm/org/json4s:json4s_scalap_2_12", "visibility||||||//3rdparty/jvm:__subpackages__", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/org/json4s/json4s_scalap_2_12", "runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/org/scala_lang:scala_library": ["lang||||||java", "name||||||//3rdparty/jvm/org/scala_lang:scala_library", "visibility||||||//3rdparty/jvm:__subpackages__", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/org/scala_lang/scala_library", "runtimeDeps|||L|||", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/org/slf4j:slf4j_api": ["lang||||||java", "name||||||//3rdparty/jvm/org/slf4j:slf4j_api", "visibility||||||//3rdparty/jvm:__subpackages__", "kind||||||library", "deps|||L|||", "jars|||L|||", "sources|||L|||", "exports|||L|||//external:jar/org/slf4j/slf4j_api", "runtimeDeps|||L|||", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/com/chuusai:shapeless": ["lang||||||scala:2.12.14", "name||||||//3rdparty/jvm/com/chuusai:shapeless", "visibility||||||//visibility:public", "kind||||||import", "deps|||L|||", "jars|||L|||//external:jar/com/chuusai/shapeless_2_12", "sources|||L|||", "exports|||L|||", "runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/com/propensive:magnolia": ["lang||||||scala:2.12.14", "name||||||//3rdparty/jvm/com/propensive:magnolia", "visibility||||||//visibility:public", "kind||||||import", "deps|||L|||", "jars|||L|||//external:jar/com/propensive/magnolia_2_12", "sources|||L|||", "exports|||L|||", "runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/com/propensive:mercator_2_12", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/org/json4s:json4s_ast": ["lang||||||scala:2.12.14", "name||||||//3rdparty/jvm/org/json4s:json4s_ast", "visibility||||||//visibility:public", "kind||||||import", "deps|||L|||", "jars|||L|||//external:jar/org/json4s/json4s_ast_2_12", "sources|||L|||", "exports|||L|||", "runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/org/json4s:json4s_core": ["lang||||||scala:2.12.14", "name||||||//3rdparty/jvm/org/json4s:json4s_core", "visibility||||||//visibility:public", "kind||||||import", "deps|||L|||", "jars|||L|||//external:jar/org/json4s/json4s_core_2_12", "sources|||L|||", "exports|||L|||", "runtimeDeps|||L|||//3rdparty/jvm/org/json4s:json4s_scalap_2_12|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/json4s:json4s_ast|||//3rdparty/jvm/com/thoughtworks/paranamer:paranamer", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
        "3rdparty/jvm/org/json4s:json4s_native": ["lang||||||scala:2.12.14", "name||||||//3rdparty/jvm/org/json4s:json4s_native", "visibility||||||//visibility:public", "kind||||||import", "deps|||L|||", "jars|||L|||//external:jar/org/json4s/json4s_native_2_12", "sources|||L|||", "exports|||L|||", "runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/json4s:json4s_core", "processorClasses|||L|||", "generatesApi|||B|||false", "licenses|||L|||", "generateNeverlink|||B|||false"],
    }

def build_external_workspace(name):
    return build_external_workspace_from_opts(name = name, target_configs = list_target_data(), separator = list_target_data_separator(), build_header = build_header())
