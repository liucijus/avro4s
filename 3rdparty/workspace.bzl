# Do not edit. bazel-deps autogenerates this file from dependencies.yaml.
def _jar_artifact_impl(ctx):
    jar_name = "%s.jar" % ctx.name
    ctx.download(
        output = ctx.path("jar/%s" % jar_name),
        url = ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        executable = False
    )
    src_name = "%s-sources.jar" % ctx.name
    srcjar_attr = ""
    has_sources = len(ctx.attr.src_urls) != 0
    if has_sources:
        ctx.download(
            output = ctx.path("jar/%s" % src_name),
            url = ctx.attr.src_urls,
            sha256 = ctx.attr.src_sha256,
            executable = False
        )
        srcjar_attr = '\n    srcjar = ":%s",' % src_name

    build_file_contents = """
package(default_visibility = ['//visibility:public'])
java_import(
    name = 'jar',
    tags = ['maven_coordinates={artifact}'],
    jars = ['{jar_name}'],{srcjar_attr}
)
filegroup(
    name = 'file',
    srcs = [
        '{jar_name}',
        '{src_name}'
    ],
    visibility = ['//visibility:public']
)\n""".format(artifact = ctx.attr.artifact, jar_name = jar_name, src_name = src_name, srcjar_attr = srcjar_attr)
    ctx.file(ctx.path("jar/BUILD"), build_file_contents, False)
    return None

jar_artifact = repository_rule(
    attrs = {
        "artifact": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "urls": attr.string_list(mandatory = True),
        "src_sha256": attr.string(mandatory = False, default=""),
        "src_urls": attr.string_list(mandatory = False, default=[]),
    },
    implementation = _jar_artifact_impl
)

def jar_artifact_callback(hash):
    src_urls = []
    src_sha256 = ""
    source=hash.get("source", None)
    if source != None:
        src_urls = [source["url"]]
        src_sha256 = source["sha256"]
    jar_artifact(
        artifact = hash["artifact"],
        name = hash["name"],
        urls = [hash["url"]],
        sha256 = hash["sha256"],
        src_urls = src_urls,
        src_sha256 = src_sha256
    )
    native.bind(name = hash["bind"], actual = hash["actual"])


def list_dependencies():
    return [
    {"artifact": "com.chuusai:shapeless_2.12:2.3.7", "lang": "scala", "sha1": "f0597f93665f4fb89dea176f8f1ccbfdbadd63fe", "sha256": "480b6567b4a61c241fcd77bac5d81095e834675249d4bff228a55ca2e435d7f6", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/chuusai/shapeless_2.12/2.3.7/shapeless_2.12-2.3.7.jar", "source": {"sha1": "319bc153645a18c067f188c6d6b54a2aa3d0bb7d", "sha256": "198bde0d48196b93449014119452b039033b824284cd7b748d360f9f79fc6b5a", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/chuusai/shapeless_2.12/2.3.7/shapeless_2.12-2.3.7-sources.jar"} , "name": "com_chuusai_shapeless_2_12", "actual": "@com_chuusai_shapeless_2_12//jar:file", "bind": "jar/com/chuusai/shapeless_2_12"},
    {"artifact": "com.fasterxml.jackson.core:jackson-annotations:2.10.2", "lang": "java", "sha1": "3a13b6105946541b8d4181a0506355b5fae63260", "sha256": "8c3cba89bf3e03b35a0e6f892c2eb17ed8fdde2e214c3a4c18703d63796bae46", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.10.2/jackson-annotations-2.10.2.jar", "source": {"sha1": "4ecdff8070b3ad24162be3441e58f7d244bbd065", "sha256": "9ab9d0a64a8d911bc2dd4edcbf76dcf43af0d9c1835f30a3117f972de55bbe90", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.10.2/jackson-annotations-2.10.2-sources.jar"} , "name": "com_fasterxml_jackson_core_jackson_annotations", "actual": "@com_fasterxml_jackson_core_jackson_annotations//jar", "bind": "jar/com/fasterxml/jackson/core/jackson_annotations"},
    {"artifact": "com.fasterxml.jackson.core:jackson-core:2.10.2", "lang": "java", "sha1": "73d4322a6bda684f676a2b5fe918361c4e5c7cca", "sha256": "4c41f22a48f6ebb28752baeb6d25bf09ba4ff0ad8bfb82650dde448928b9da4f", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.10.2/jackson-core-2.10.2.jar", "source": {"sha1": "387baaa5f80e83cd14b49fdb8f7aeb6989d6f35a", "sha256": "3f356724ca7a5ba77a18e5448e31d544a4e04b9beca585f680fed81ff80767fb", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-core/2.10.2/jackson-core-2.10.2-sources.jar"} , "name": "com_fasterxml_jackson_core_jackson_core", "actual": "@com_fasterxml_jackson_core_jackson_core//jar", "bind": "jar/com/fasterxml/jackson/core/jackson_core"},
    {"artifact": "com.fasterxml.jackson.core:jackson-databind:2.10.2", "lang": "java", "sha1": "0528de95f198afafbcfb0c09d2e43b6e0ea663ec", "sha256": "42c25644e35fadfbded1b7f35a8d1e70a86737f190e43aa2c56cea4b96cbda88", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.10.2/jackson-databind-2.10.2.jar", "source": {"sha1": "0f65a9cc329f6a29eff8812536153a89a7562dbc", "sha256": "6436b499a6d31caf37b2a03af3d1729c9d53b9971fbf40b9239da8551b3e8db6", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.10.2/jackson-databind-2.10.2-sources.jar"} , "name": "com_fasterxml_jackson_core_jackson_databind", "actual": "@com_fasterxml_jackson_core_jackson_databind//jar", "bind": "jar/com/fasterxml/jackson/core/jackson_databind"},
    {"artifact": "com.propensive:magnolia_2.12:0.17.0", "lang": "scala", "sha1": "f3d7f734c38e05206a086b5e4124e1dc3e24fc96", "sha256": "7accc5f93399fbe99c9d6dc1f4a8a82263d63b7ecb5d98bd3e5c1d0abb6f0450", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/propensive/magnolia_2.12/0.17.0/magnolia_2.12-0.17.0.jar", "source": {"sha1": "d1a69bed0a2fb61dbf12e5b26c4ab1240e00b492", "sha256": "6668cbfae9263a2542f6ac78b0aa1db0d4da557614adb4d03973bc44c7da694c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/propensive/magnolia_2.12/0.17.0/magnolia_2.12-0.17.0-sources.jar"} , "name": "com_propensive_magnolia_2_12", "actual": "@com_propensive_magnolia_2_12//jar:file", "bind": "jar/com/propensive/magnolia_2_12"},
    {"artifact": "com.propensive:mercator_2.12:0.2.1", "lang": "java", "sha1": "b4619ba60c7cf262d4ff5e442eb612cf7434d61d", "sha256": "1deef9a53201b3f05dea6bdd6cd3d355720a7a8423f119c9993ad6a8e12bda49", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/propensive/mercator_2.12/0.2.1/mercator_2.12-0.2.1.jar", "source": {"sha1": "537319cbdfbae24fc43d68782267a0f06570c1fa", "sha256": "e5dc8f9e19a9533c8f69af24a4ac2ab91d09d9799a291e3ad10d55357b7ce9df", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/propensive/mercator_2.12/0.2.1/mercator_2.12-0.2.1-sources.jar"} , "name": "com_propensive_mercator_2_12", "actual": "@com_propensive_mercator_2_12//jar", "bind": "jar/com/propensive/mercator_2_12"},
    {"artifact": "com.thoughtworks.paranamer:paranamer:2.8", "lang": "java", "sha1": "619eba74c19ccf1da8ebec97a2d7f8ba05773dd6", "sha256": "688cb118a6021d819138e855208c956031688be4b47a24bb615becc63acedf07", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/thoughtworks/paranamer/paranamer/2.8/paranamer-2.8.jar", "source": {"sha1": "8f3421a8203053a6ab4b74f76a0550d21eee8cfe", "sha256": "8a4bfc21755c36ccdd70f96d7ab891d842d5aebd6afa1b74e0efc6441e3df39c", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/com/thoughtworks/paranamer/paranamer/2.8/paranamer-2.8-sources.jar"} , "name": "com_thoughtworks_paranamer_paranamer", "actual": "@com_thoughtworks_paranamer_paranamer//jar", "bind": "jar/com/thoughtworks/paranamer/paranamer"},
    {"artifact": "org.apache.avro:avro:1.9.2", "lang": "java", "sha1": "7e67193b94e45d32277ac480ea86421fd3976424", "sha256": "9d8f65504604b5fcdffb96793a9a32ca7b10bc0a469425d1d1fe4aa490c31c02", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/avro/avro/1.9.2/avro-1.9.2.jar", "source": {"sha1": "cfe4e9cba787ac5bbf6e9597d47e19b75d5f21e3", "sha256": "e587a7cd684103c0ce528eef98908a978f1ee338f7758960001a086a9aa782d0", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/avro/avro/1.9.2/avro-1.9.2-sources.jar"} , "name": "org_apache_avro_avro", "actual": "@org_apache_avro_avro//jar", "bind": "jar/org/apache/avro/avro"},
    {"artifact": "org.apache.commons:commons-compress:1.19", "lang": "java", "sha1": "7e65777fb451ddab6a9c054beb879e521b7eab78", "sha256": "ff2d59fad74e867630fbc7daab14c432654712ac624dbee468d220677b124dd5", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.19/commons-compress-1.19.jar", "source": {"sha1": "9c242093f81288289bc433e383c8a8de89489406", "sha256": "3952fb4e01ea5fc03ae25e0dab2f3d5b4f71a71d3750c7f03dffa6aba8075757", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.19/commons-compress-1.19-sources.jar"} , "name": "org_apache_commons_commons_compress", "actual": "@org_apache_commons_commons_compress//jar", "bind": "jar/org/apache/commons/commons_compress"},
    {"artifact": "org.json4s:json4s-ast_2.12:3.6.11", "lang": "scala", "sha1": "68f2fdf7ba5e93d90fe22ad91cb94cd40de07dd9", "sha256": "fc7f0e7db13eb1d4ba1f7218f2865b756719ee949b6cd91feea6d609e6cf7410", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json4s/json4s-ast_2.12/3.6.11/json4s-ast_2.12-3.6.11.jar", "source": {"sha1": "c18000242beb8d44136d9aa27bd021d7b5f049da", "sha256": "15bc2b254ca74cf7189f0e73554ff79295b83db1823ef0e2f68aab1a43d97cdb", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json4s/json4s-ast_2.12/3.6.11/json4s-ast_2.12-3.6.11-sources.jar"} , "name": "org_json4s_json4s_ast_2_12", "actual": "@org_json4s_json4s_ast_2_12//jar:file", "bind": "jar/org/json4s/json4s_ast_2_12"},
    {"artifact": "org.json4s:json4s-core_2.12:3.6.11", "lang": "scala", "sha1": "89d24afbbb75a230da2f88c6546fe00d4255e629", "sha256": "d0991fc32314ab642a21a3d121f23b1e1e1b700aa59aa6e8d2e5beae992eb49f", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json4s/json4s-core_2.12/3.6.11/json4s-core_2.12-3.6.11.jar", "source": {"sha1": "9f3851ae6658e0b203c28a5eed40f58330866eb0", "sha256": "72fc1d67a08119c8202c880d60eb3c03eba5b7ec88bb540d9ecba32950fda1ab", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json4s/json4s-core_2.12/3.6.11/json4s-core_2.12-3.6.11-sources.jar"} , "name": "org_json4s_json4s_core_2_12", "actual": "@org_json4s_json4s_core_2_12//jar:file", "bind": "jar/org/json4s/json4s_core_2_12"},
    {"artifact": "org.json4s:json4s-native_2.12:3.6.11", "lang": "scala", "sha1": "42ebb585211e11d0339e9cfae189c113514ae9b9", "sha256": "b469f93200c8bf1286dfb3fa3ebbb1a49603f890b552249d99e1b1d537bf37f5", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json4s/json4s-native_2.12/3.6.11/json4s-native_2.12-3.6.11.jar", "source": {"sha1": "42ec06da8e80130f02b8048ea90dd08e64c66bee", "sha256": "a6dd31db1a0258dc30cba316e77c752dede80b7d719c908d70d94c3228efcff6", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json4s/json4s-native_2.12/3.6.11/json4s-native_2.12-3.6.11-sources.jar"} , "name": "org_json4s_json4s_native_2_12", "actual": "@org_json4s_json4s_native_2_12//jar:file", "bind": "jar/org/json4s/json4s_native_2_12"},
    {"artifact": "org.json4s:json4s-scalap_2.12:3.6.11", "lang": "java", "sha1": "db995bb4b86c5e7824441dc2529e6139c031a197", "sha256": "e9eb34ab674be4840f935996ae39c43289b61ebed3437aeba7c1efc8c1e48038", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json4s/json4s-scalap_2.12/3.6.11/json4s-scalap_2.12-3.6.11.jar", "source": {"sha1": "90906879e9a31357842fbf6679cb5382ab6aa32b", "sha256": "5f05df22939bcec85726db47fdc95c08ab42bf65ec6387a369a014ecd62e69dd", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/json4s/json4s-scalap_2.12/3.6.11/json4s-scalap_2.12-3.6.11-sources.jar"} , "name": "org_json4s_json4s_scalap_2_12", "actual": "@org_json4s_json4s_scalap_2_12//jar", "bind": "jar/org/json4s/json4s_scalap_2_12"},
# duplicates in org.scala-lang:scala-library promoted to 2.12.13
# - com.chuusai:shapeless_2.12:2.3.7 wanted version 2.12.13
# - com.propensive:magnolia_2.12:0.17.0 wanted version 2.12.11
# - com.propensive:mercator_2.12:0.2.1 wanted version 2.12.8
# - org.json4s:json4s-ast_2.12:3.6.11 wanted version 2.12.13
# - org.json4s:json4s-core_2.12:3.6.11 wanted version 2.12.13
# - org.json4s:json4s-native_2.12:3.6.11 wanted version 2.12.13
# - org.json4s:json4s-scalap_2.12:3.6.11 wanted version 2.12.13
    {"artifact": "org.scala-lang:scala-library:2.12.13", "lang": "java", "sha1": "c4a2c5f551238795136cb583feef73ae78651e07", "sha256": "1bb415cff43f792636556a1137b213b192ab0246be003680a3b006d01235dd89", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scala-library/2.12.13/scala-library-2.12.13.jar", "source": {"sha1": "6c0e8771af95c1659a3bc894a8feb1f9757986f2", "sha256": "d299cc22829c08bc595a1d4378d7ad521babb6871ca2eab623d55b80c9307653", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/scala-lang/scala-library/2.12.13/scala-library-2.12.13-sources.jar"} , "name": "org_scala_lang_scala_library", "actual": "@org_scala_lang_scala_library//jar", "bind": "jar/org/scala_lang/scala_library"},
    {"artifact": "org.slf4j:slf4j-api:1.7.25", "lang": "java", "sha1": "da76ca59f6a57ee3102f8f9bd9cee742973efa8a", "sha256": "18c4a0095d5c1da6b817592e767bb23d29dd2f560ad74df75ff3961dbde25b79", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar", "source": {"sha1": "962153db4a9ea71b79d047dfd1b2a0d80d8f4739", "sha256": "c4bc93180a4f0aceec3b057a2514abe04a79f06c174bbed910a2afb227b79366", "repository": "https://repo.maven.apache.org/maven2/", "url": "https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25-sources.jar"} , "name": "org_slf4j_slf4j_api", "actual": "@org_slf4j_slf4j_api//jar", "bind": "jar/org/slf4j/slf4j_api"},
    ]

def maven_dependencies(callback = jar_artifact_callback):
    for hash in list_dependencies():
        callback(hash)
