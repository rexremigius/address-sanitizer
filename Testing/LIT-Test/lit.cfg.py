import lit.formats

config.name = "ASAN_TEST"
config.test_format = lit.formats.ShTest(True)

config.suffixes = ['.ll']
