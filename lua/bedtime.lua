
local hexcodes = {
{"d5b473","d5b776","d5b978","d6b979","d6b87a","d7b97d","d8b97e","d8b981","d9bb84","d9bc87","d9bd89","d9bd8a","d9bd8d","d9be8b","d9c08c","dac18c","d9c18d","dac08d","dac08d","dabf8e","dac190","dbc090","dcc090","dcc092","dbc295","dac397","d9c090","d4ae5f","dfb458","dcbd7c","d7c094","d6bf94","d6bf92","d6c090","d7bf8f","d8c190","d8c290","d8c390","d8c490","d8c492","d9c291","dbc092","dbc094","dbbf96","dac195","d8c592","d7c78f","d7c691","d8c695","d8c698","d8c798","d8c796","d8c794","d8c695","d8c696","dac898","dcca9a","ddc999","ddc696","dbc594","dcc696","ddc999","dcc697","dbc495","dcc393","dbc294","d8bd90","d9bf91","dbc092","dbbf92","dac093","dac093","d9c193","d8c193","d8c192","d8c190","d8c08e","d8c08c","d8bf8d","d9bc8d",},
{"d5b676","d5ba79","d6bc7a","d7ba7a","d8ba7d","d8bb81","d8bd84","d8bd87","d9be89","dbbd8a","dbbd8a","dbbd8b","dbbd8c","dbbe8d","dcc08e","dcc290","dcc392","dcc392","dcc392","dcc392","dcc392","dcc493","dbc494","dac494","d9c294","d3bd95","c7b08e","bba375","baa371","b8a688","b8ab96","b5aa95","afa48f","a89c89","a69b88","a79c89","a89c88","aa9f8a","b3a78e","bfb093","cfbc99","d6c194","d8c292","d9c192","dac192","dac390","dac38f","d9c491","d8c795","d7c797","d8c799","d8c799","d8c698","d8c698","d9c698","dbc799","dcc798","dcc696","dbc695","dbc595","ddc699","dbc498","dbc495","dbc394","dabe8f","d8bf8e","d8c18f","d8c290","d8c290","d8c090","d8c290","d8c290","d8c18f","d8c18f","d8c08e","d8c08e","d8c08e","d8bf8d","d8be8d","d8bd8a",},
{"d6b978","d7b97a","d8ba7b","d8ba7d","d9bb81","d9bd84","d9bf87","d9be88","dbbf8b","dcbe8c","dcc08c","dcc18c","dcc18d","dcc18f","dcc391","dbc492","dcc593","dcc593","dcc593","dcc593","dcc492","dac494","d1c095","bdaf90","aa9d8f","9d9390","978f8c","938c87","918c87","918d88","95928e","989596","939295","918f93","939296","908f91","8e8c8d","908c8b","8f8a87","8f8a83","928c80","9d9581","b5a789","d0bb92","d7c294","d9c191","dac18e","d9c38f","d8c691","d8c696","d8c799","d8c799","d8c698","d8c799","dac696","dcc393","dcc494","dbc394","dcc394","dbc294","dac193","d9c194","dbbf93","d9bd8f","d9bc8c","d8c08e","d8c18f","d8c18f","d7c18f","d7c18f","d7c08f","d7c08f","d7c18f","d8c18f","d8bf8e","d8bd8d","d8bd8c","d8bd88","d8bd87","d8bd87",},
{"d8b979","d8ba7c","d8ba81","d8ba84","d9bc85","d9c088","d8c28a","d9c18b","dbbf8c","ddbf8d","ddc08e","ddc18f","ddc08e","dcc392","dcc593","dcc593","dcc593","dcc593","dcc491","dbc393","d4c097","b5a999","9d9898","989499","979599","929190","908d88","908b83","908b82","938f86","9c9a93","989796","908f94","8e8d90","8c8b8c","8e8e8e","918f90","8c8b8a","8d8a89","8e8a89","8e8a88","8e8a84","91897f","94887c","ac9d84","cfbb96","d8c293","d9c48f","d8c592","d8c698","d8c797","d8c697","d8c597","d8c595","d9c392","dabf8f","dabe8f","dbbf90","dcc091","dabe8f","dabe8f","d9c190","d8be8d","d8bd8d","d9bf8e","d8c08e","d7c08e","d7c08e","d7c08e","d7c08e","d7c08e","d7c08e","d7bf8d","d7bf8d","d8be8c","d7bd8b","d8bc8a","d8bc87","d8bc87","d9bc87",},
{"d8b677","d8b77a","d8b87c","d8b97f","d8bb81","d8be84","d7c087","d9bf89","dbbd8a","dcbe8c","dcc08c","dcc18c","dcc08e","dcc091","ddbf91","ddc091","dbc392","dbc391","dac18e","ceba92","a4a197","9294a1","9397a0","95979a","919192","929290","94918c","918c84","908880","938d84","9c968e","999796","929195","8d8b8f","8f8d8d","8b898a","8f8d8d","8d8c8a","8d8b88","8d8c8a","8d8a89","8d8785","908b86","8f8a83","908981","998b7e","c5af96","d8c298","d8c393","d8c494","d8c594","d7c394","d9c395","dac493","dac392","dbc291","dcc090","dbbf90","dbbf90","dabf8f","dabe8e","d9bd8d","d8be8d","d8be8d","d8be8d","d7bd8d","d6bd8d","d6bc8c","d7bb8b","d7bb8b","d6ba89","d7bb89","d7bb89","d6ba89","d7bb89","d7bb89","d7ba89","d8b988","d8b988","dab988",},
{"d5b273","d5b374","d5b475","d5b677","d5b978","d6b979","d6b97b","d7ba7e","d7ba83","d8ba86","d9bc88","d8bd88","d9bd89","d9bd8a","d9bd8c","d9bd8c","d9be8d","d9be8a","d2bd91","a79c93","9494a4","989ba8","969aa2","919297","959698","949493","918f8a","93877f","9c857a","b29486","bea08f","ac9389","958c88","928e8d","8f8d8b","8d8c8a","8c8a87","8f8d8a","8f8d89","8f8f87","8e8980","8f887f","918a82","918c85","8e8982","948b81","9c8a74","c5ad8c","d4bd92","d5be90","d5bf8f","d7c192","dbc598","dcc696","dcc495","ddc495","ddc393","ddc392","dcc492","dbc492","dcc291","dcc291","dbc391","dbc392","dbc392","dbc391","dcc291","dcc291","dcc392","ddc191","ddc192","dec292","ddc292","dec292","dec292","dfc290","dfc18e","e1c28c","e2c48c","e4c48a",},
{"d7b675","d8b777","d8b978","d8bb79","d7bd7c","d8bd7f","d8bd82","dabd86","dbbd89","dcbd89","dcc08b","dcc18c","dcc18c","dcc18c","dcc18c","dcc08d","dbc08e","dbbf8e","c0af91","9a9798","9398a7","9aa0aa","8d929a","969aa2","96989e","969897","999189","ab9284","c8a28c","daad93","daad94","cca690","b2998b","978885","918887","918c89","8d8986","8f8a86","928c87","948d85","918980","92887f","958b82","968c82","92887e","978d83","9f8c78","a58d71","d3bd97","d7c294","d8c392","d9c594","ddc898","e0cb9b","e3cda0","e4cda1","e4cda0","e4cd9e","e4cd9c","e4cd9c","e4cc9b","e4cc9b","e3cc9b","e3cc9a","e3cc9a","e4cc9a","e4cc9a","e4cc9a","e4cb99","e5c998","e6c996","e7ca98","e9cc98","ebcd9a","eccf99","edd099","eed198","f0d196","f0d196","f0d196",},
{"d7bb7c","d9bc7f","d9bc80","dbbd82","dabd84","dbbe87","dcbe8b","dcbf8d","ddc090","dec090","dec390","dec590","dec591","dec593","dfc393","dfc493","ddc493","dbc392","b7ab8d","909293","99a1ab","979ea8","8c939c","979ca6","96989e","9d948c","be9c87","d5aa91","e2b69a","e3b89c","e1b59a","deb398","d4aa90","b89c8d","9a8c85","948d85","938b83","948c83","9a9389","968d83","95897d","988c7f","95897a","998d7e","97897b","96877a","a29282","968573","bdae90","d8ca9e","dbc99c","ddc99d","dfcba0","e1cca2","e4cea2","e4cda2","e4cda2","e5cea2","e6cd9f","e6cb9e","e6cc9e","e6cb9d","e6cb9d","e6cd9c","e7ce9d","e8ce9c","e8ce9c","e9d09d","ebd29d","ecd39e","edd39d","edd39d","edd39b","eed49a","eed499","efd498","efd498","f0d39a","f0d39a","f1d498",},
{"ddbf88","dec08b","dec08b","e0c28d","e0c28e","e1c590","e0c791","e0c794","e0c797","e1c899","e1c89a","e2ca9b","e2cb9d","e1cc9e","e1cb9f","e0cc9f","e1ca9c","dfca9b","bfb295","929393","9ba2aa","9397a0","989da7","8f969e","978c90","b99b91","d8b19e","e3bda9","e6c1aa","e6bea6","e3b79f","e1b59c","e0b49a","d8b19f","b3968d","988a85","948d86","958e85","979087","989085","96897f","9f9083","9a8b7d","98897b","958a7b","978d7d","958a7b","8d8175","aca08c","dacda1","dbcea3","decea4","e0cea4","e2cea3","e5cfa4","e6cfa2","e6cfa1","e7d0a1","e8cfa1","e9cfa0","ead0a0","ead19e","ecd29f","ecd39e","ecd39e","edd39e","edd49e","edd59e","edd49d","eed39c","f0d29a","f1d299","f1d197","f0d297","f0d397","f0d398","f0d398","f0d398","f1d499","f0d699",},
{"dfc189","dfc28c","e0c38d","e0c48e","e0c58f","e0c792","e1c893","e2c795","e3c798","e4c899","e4c99a","e4cb9c","e4cb9c","e3cd9e","e4ce9f","e3ce9f","e3ce9e","e3cd9d","c9b694","948c83","9c9da1","989b9f","9ca3aa","8f9299","9d8a8e","b8a19c","baa59f","b9a39e","bba69c","c6a997","d4ac93","dfb29b","e0b29b","daac98","c29e8f","968a84","8f8d8a","8e8c88","908c87","938f89","928b85","968c81","9d9285","94897e","94877c","a08879","b48d7a","9f7f72","bbae98","dbcea2","ddcfa4","ded1a6","dfcfa6","e3d0a6","e8d3a8","ead4a5","ebd4a2","ebd5a3","ecd5a3","ecd5a3","ecd5a1","ecd69f","edd69e","ecd69d","edd79d","eed69d","efd49c","f0d29c","f0d29c","f0d39b","f1d197","f1d196","f1d196","f1d196","f1d196","f1d297","f1d399","f1d49a","f1d499","f0d699",},
{"e0c289","e0c58d","e0c78f","e0c890","e1c890","e2c991","e4c993","e4c894","e4c896","e4ca99","e5cd9b","e6ce9c","e5ce9c","e6d09f","e7d0a0","e7d2a1","e5d3a1","e5d3a3","dccca2","e0c0a4","cdb3a7","a4a6a5","9da1a5","919396","a29593","bdaaa1","c2ada1","bba495","c1a18b","cd9b82","d5a488","dfb59c","e1b69f","d39e88","c1907f","9a8981","918f8a","928f8a","938e89","948f89","968e88","998d82","9d8e7f","a79482","b59d81","d0a177","cc7c4e","cd7f5f","d6c3a0","ded0a4","ded1a4","dfd2a5","e0d0a5","e4d2a6","ebd6a8","ebd7a6","ebd7a4","ebd7a4","ebd7a4","ecd7a3","edd7a2","edd6a0","edd69d","edd69c","edd69c","eed69c","f0d39b","f0d39b","f0d29c","f0d39b","f1d196","f1d196","f1d196","f1d196","f1d398","f0d399","f1d49a","f0d699","f0d699","f0d699",},
{"e1c38a","e2c58d","e3c58e","e3c690","e3c792","e4c895","e5c996","e5c998","e5c999","e7c998","e7cb9b","e7cd9d","e8cf9e","e8d2a1","e9d4a3","ebdbb0","f6edca","fbf6d7","fbfadd","e6c8af","e1b6a8","bcbcbb","bdbdbf","999699","baa9a5","c8bcb2","ccc0b7","cebeb3","d1b8ab","d5b4a7","d4aea0","cba597","dbb09e","c89676","b9a284","9db498","81af95","7fa18b","85a090","87a194","929f98","9f9498","9b8988","a48a7d","a38371","b78465","dd8d5c","ca986e","ddcda8","dfd0a5","e0d0a7","e1d1a6","e2d0a3","e4d2a4","ebd7a7","ebd7a4","ebd7a4","ebd7a4","ebd7a4","ecd6a3","edd5a3","efd3a0","ecd097","e9c987","eac882","eac881","ebc880","ecc77f","ecc77e","edc77e","edc77e","edc67e","eec67c","efc67c","efc77d","efc77c","efc67c","f0c67c","f0c67d","f1c67b",},
{"e3c38d","e4c58d","e4c68d","e4c691","e4c693","e5c795","e5c895","e6c896","e7ca97","e6cc99","e7ce9c","e7d09e","e8cf9f","e9d2a6","ebd7a9","fdf2cd","fdfcec","fcfdf7","fbfcf2","ece5cd","d6cbb3","a6a4a4","a4a3a6","989290","c39f8d","d3a892","d3af98","d3b09c","d6b3a1","d8b6a7","d7b9ab","e6c6b8","e6bb9f","e3a57c","cd8962","af866f","958c84","96938f","959491","939391","939391","8f8c8c","918b8b","998e82","a18671","d6986c","e09556","cbaa79","decba4","e0d0a6","e0d0a6","e3cfa6","e3cea4","e6d1a3","ebd7a6","ebd7a4","ebd7a4","ebd7a4","ebd7a4","ebd5a2","ebd09a","e7c787","ddb66a","e5b45d","e8b868","e6bd78","e5be7a","e5be78","e5bf77","e5bf77","e5bf77","e5bf76","e5bf76","e5bf76","e5bf75","e4bf73","e4bf73","e4bf74","e4bf74","e4be73",},
{"e2c38b","e3c48e","e4c58e","e4c591","e4c894","e5c894","e6c793","e7c794","e8c895","e7ca98","e7cc9c","e7cf9d","e7d09e","e9d3a4","ead7a7","f0e2b6","fbf9dd","fcfdf3","fbfcf7","f7f3dd","d0c8af","9e9c9b","a09da1","998c8b","c9aba4","dfbaaf","e3bdab","e2b8a5","dfb6a4","e4beb2","eac9c1","e7c6bc","e2b49d","e2a282","e2956f","d69371","9d8373","918b88","92918f","90908e","908f8d","8d8b8b","8d8c87","968d85","9f8879","b69075","ae8669","d6bd97","ddc9a1","e1cea7","e0d0a7","e2d1a5","e4cea4","e6d1a3","ebd7a5","ebd7a4","ebd6a3","ebd6a3","ebd5a2","e2c994","e2b464","eab155","eebf71","efcd89","eed196","edd39e","ecd39f","edd3a0","ecd4a1","edd3a2","edd3a2","eed4a1","eed49e","efd29c","efd39b","f0d199","f0d199","f1d199","f0d199","efd39a",},
{"e1c182","d9b874","d9b668","dbb566","dbb666","dbb766","dcb767","dcb666","ddb767","ddb869","ddb86e","deb971","dfbc72","e2be78","e3bf7a","e5bf7b","e7ce87","fcf6cb","fdf9f0","f5f1d8","c9c5a7","9d9c90","9b9c9b","9a918d","c6afa5","dcbeb3","e1bfaf","e0bcaa","e4c1b1","e9c8bd","dabbb7","d7b5af","d6ab92","d69f84","d58e71","d68d6e","b58b6f","998b80","908e8c","8f8e8c","8d8c8a","8f8e8d","8a8986","938b82","998c7f","978679","a08f7d","d4c4a1","dccea4","e0d0a4","dfd1a5","e2d0a5","e4cea5","e6d1a6","ebd6a6","ebd7a4","ebd7a4","ebd7a4","ead5a3","e0c993","e4b55c","f0bd5d","f0d086","eed49a","edd49d","edd49d","ecd69d","ecd69d","edd69d","eed6a0","f0d5a0","f0d5a0","f0d49f","f0d39b","f0d398","f1d196","f1d296","f1d196","f1d397","f1d497",},
{"d6ae61","d7a85c","dabc82","dbc89a","d9c18e","d9bc84","dbbb81","dcba82","debc85","dfc08a","e0c590","e0ca93","e1cc95","e2ce98","e4d09b","e3d099","dfc387","e5ca8b","f8ebbd","eee8bf","e5e1bc","a5a595","989797","998e8c","cab9b1","d5bdb3","dfc5b6","e2c8b9","e3cabc","e6d0c3","e5c7c2","e1b1ae","dea491","de9a82","de916e","db936d","c79173","a78c7f","908c88","8d8b8a","8d898b","908a8a","8e8680","a19186","97897a","958578","a2917e","d1c29e","dbcda4","e0cfa5","dfd2a6","e2d0a6","e4cea6","e6d1a6","ebd6a7","ebd7a4","ebd7a4","ebd7a4","ebd5a2","e2c993","dfb56b","e9b35c","efbe6d","eecc87","eed297","edd49c","edd59d","ecd69d","ecd79f","edd79f","edd79f","edd79f","eed59d","eed59d","eed59b","eed69a","efd499","f0d396","efd497","eed796",},
{"ddb162","d9c289","d9cba0","daceae","d9cca2","d7c68e","d9c389","dac287","dac38a","dcc793","dccc9d","ddcfa2","ded0a5","e0d2aa","e1d4ae","e2d4ad","e3d2ac","decda6","d2bb7e","dcb66d","e8cb9c","b4ad9a","9b9999","979493","a79e9a","cfbfb8","dfc8bd","e2c7bb","d9bfb3","dec0b5","dcb2ac","de9a99","dd8b84","de8472","dc8366","d48968","d09070","bc8f76","9f8e7e","8c8a82","8d898c","8f8888","9f908b","9b867e","93867b","91877d","9a8c7a","ab9c7e","c9bb96","dacba3","e0d1a9","e2d0a9","e2cfa9","e6d1a8","ebd7a6","ebd7a4","ebd7a4","ebd7a4","ecd5a2","ecd4a2","e9d19c","e6c891","e3bb73","e8bb5e","ebbc62","ecbc6c","ecbc6c","ecbc6d","ecbd6f","ecbd70","edbd6d","edbd6d","edbe6f","edbd6f","edbd6e","eebc6e","eebc6e","eebc6d","efbd6e","eebf6f",},
{"e4ba70","dcc798","d8cba2","ddd0b1","dfd2b5","dbcca2","dac38c","dabe81","d8bf86","d8c494","daca9f","dacca3","dccea9","ddcfad","ddd1b0","ddd2b1","ddd1b1","d9cdac","d6bf83","e4b556","e6c385","c4baa4","a3a1a0","949395","9c999a","a29b9a","c5b6b1","ddcac1","e1cdc1","e5d2c5","e4cfc1","dfc0b1","dfb4a2","deaa8c","e0a379","e0996b","da936b","c48b6c","a78c75","928a82","8e8888","918887","928682","92857f","8f867f","918981","988a7c","a69680","bcad8d","cdbe9a","d6c6a2","decda8","dfcea7","e2d1a6","e9d6a7","ead7a6","ead7a5","ead7a4","ebd6a4","ebd6a3","ebd5a3","ead3a2","e6cd99","e4ca8d","e4c88c","e4c88b","e4c88a","e5c889","e6c88a","e6c889","e6c887","e6c888","e6c789","e6c689","e6c688","e7c588","e6c587","e6c686","e6c686","e6c685",},
{"e2c07c","ddcea3","dacca1","ddd1a9","e1d5b6","dfd3af","dcc89c","d8c08a","d6c08a","d7c38f","d9c79a","dac9a2","dccca7","ddcfad","dcd2b0","dcd3b1","dcd1b2","dcd1b1","d8c084","e1b053","dfbb7d","bcb09d","a29ea2","8d8b90","908e92","a2a0a4","9d979a","c5bab3","dcccbc","ddcabc","ddc6b9","d8bcae","d6b3a0","d6aa8d","d39f7e","d19876","cd8f6d","be876d","a68777","948a86","96908c","8f8b85","8b8782","8d8886","8b8684","8c847d","9f9082","b09e8b","b7a78d","c5b598","d1c2a2","dacca8","dbcfa6","dfd1a5","e6d5aa","e7d6a8","e7d6a5","e8d6a5","e8d5a4","e8d5a3","e9d5a3","e9d4a3","e9d4a3","e9d4a2","ead4a1","ebd3a0","ebd29e","ecd29e","edd29e","edd39e","edd59d","ecd69d","ecd69e","ecd69e","edd69d","edd69d","edd69c","edd69b","eed49b","eed49c",},
{"e2c583","dbd2aa","dccea1","dfcc9a","e1d5ab","e4d6ae","e1cda2","dac591","d5c18a","d4c189","d6c494","d8c59d","d8c9a2","d8cba6","d9cda8","d8cfa9","d8cda8","d6cca6","d0bb87","cca26e","baa182","a6a39e","9e9da0","8e8e90","8e8e90","969696","979594","b0a69e","e1cdbf","e8d0c4","e4cdc0","dbc3b6","d4b3a3","d2a48b","d1997d","ce9478","c99379","bf927d","a5897d","afa3a0","a09795","8b8581","898582","8b8686","8c8784","8f8882","a3998e","92877b","8e837c","918881","968f87","9a9388","9d9589","9d9488","9c9486","a09688","a69b8c","aa9f8d","ab9f8b","aca18c","b0a48e","b6a68f","b8a88e","baaa8c","bfab8a","c1ac8a","c3ad8b","d5bf97","ebd29f","ebd29b","ecd29a","edd39c","ecd59d","ecd59d","edd59f","edd5a0","eed59e","efd49b","f0d199","f1d196",},
{"e5cd8c","e0d9ba","ded0a5","e1cc97","e0cd9e","e3d4a9","e3d4a8","dcca99","d8c38b","d9c48a","dec897","dfcba0","dfcfa3","dfd4a9","e1d6af","dfd7b0","ded6ae","ddd6aa","d0be91","c3a17f","b0a492","a2a1a0","99999a","959394","9b9997","96948f","b1ada8","99928a","d1c3b7","e7cec2","e9d4c7","e8d2c3","e0c5b4","d6b79d","d4b196","d6b5a1","d8c0b1","cab8ab","c8bcae","aca69f","8c8885","8c8786","8c8787","8b8888","8d8885","99948f","98938c","908c85","8f8c86","8f8d89","8f8f8b","90918c","91918e","92918e","93928e","94928e","95928f","96928e","97938c","98938c","98938c","989289","989187","9a8f83","9c8f7e","9e8d7c","a08c79","a38c75","b59872","dcb475","e2b05f","e3b059","e4b05a","e4b05a","e4b158","e5b155","e6b154","e6b155","e6b154","e6b153",},
{"e8ce8d","e7dfc5","dfd6b3","ded0a7","decd9f","dfd1a9","e3d5b1","ddd0aa","dbc895","dbc589","dcc690","ddc998","dfcda0","e0d0a5","dfd3a9","e1d8ae","f6eec7","f8f1ca","dcd3a3","beaa8b","ada092","aba69a","baae98","bdaf95","b8a78e","c1b19a","dad4d1","aaa5a6","a99f99","d9c3b6","e6d2c3","e6d2c4","ddcec3","e2d6cc","e7dcd4","e5dbd3","dcd4cc","d9d3cd","bbb6b3","918e8e","8f8d8d","8f8d8d","8f8d8d","8e8c8d","a8a5a5","aeaaa8","8d8987","908c8b","918d8d","91908f","929091","929192","929291","939392","939391","949393","949394","949395","939395","959494","959591","94928d","96928a","978f86","998e80","9d8d7f","a08e7d","a28e78","a58c74","b39677","e4ca9a","e6ca95","e7c58e","e6bf84","e3bb7d","e7bd7a","eac07d","e8bf7b","eac27b","eac580",},
{"e5c990","e9e2cd","e1dcbf","d8d2b3","ddcdab","ddcfa3","ddd2ae","dfd4b4","ddca9d","d9c488","d7c186","dac590","dcc795","ddcb9a","dfcd9f","dfcea3","f1e4b9","f9f3cf","e8deb1","ddbc72","e5cc8a","e3cea4","decba3","d3c5a2","cac4ab","9f9d96","c7d1db","e2edf5","dfe7ec","dadcdc","dcd4cc","e8e0db","efeeed","edebeb","e6e2e0","e1ded7","dad9d0","cccac8","9a989a","979598","969496","959495","949495","a5a5a6","c9c9c7","90908d","908f8e","939293","939395","949394","949294","939395","939397","939397","949498","959499","959498","969498","959397","989699","949192","94908b","948e86","948f85","948e84","958d83","978e80","9d8f7e","a4937e","ab947a","bd9e76","e3b878","e5b061","e4ad65","e4ad6c","e6ad6e","e7b070","e4af67","e7b260","edb15f",},
{"c79781","dfc4b2","e8d7c3","e0d7c1","dcd3b7","dcd2a6","dcd0a9","e2d5b2","e2d3a7","dac690","d9c188","dcc690","dec994","dfcb98","e0cc9b","e0cc9f","dfd1a5","eeeac0","eddea8","e9b663","e8c88c","cec6af","adb0a9","acbabb","a2b0bc","828b97","afb8c1","e2eef4","d1dde5","acb7bf","a0a8b1","a7adb3","bbbec0","d7d8d8","e1e2df","dee0da","dadbd7","a9aaa8","9a9a9c","98989c","96969c","94979c","94979c","d3d7da","a5a6a5","8f908e","939395","98979c","949599","949496","959596","959598","96959a","97959a","96969b","96969b","97969b","959499","949297","969598","939394","94928e","95928a","979089","979189","989188","979188","978f85","988e82","9d8f7e","a69179","ba9a71","debd8d","e4c395","ebcb9c","efce9e","f0d09d","eaca94","e7c58d","ebc285",},
{"b47c6d","b87f6f","cb9884","e2c4ae","ded3b8","d9d4ae","ded1ac","e2d3ab","e5d6aa","e0cf9e","d9c892","ddcc95","dfcd99","e0ce9c","dfcf9f","dfcf9e","dfd2a3","dad2a6","cbc6a5","bab4a3","a6aaaa","91a1a9","b2c7ce","a4bbc1","8c9da6","828b96","c4cbd4","d7e4ea","a1afb7","9eaab4","979fab","8e919a","8e8e90","989697","bdc0c1","d7dcdf","c4c8cf","9598a0","9698a0","9498a0","9497a1","9296a1","adb2bd","c6ced5","888d8f","939495","9d9d9f","9b9b9c","969698","979698","979799","95979b","95969c","95969c","96979b","96979b","96969b","929196","939297","969497","949294","949291","94928f","95928d","95918c","969189","968f88","988f88","988f87","999084","9b8f7f","a58f79","c1a587","e5c39e","e6c49b","e5c496","e8c797","eacb98","e9cb98","e9c995",},
{"ad7f74","b18171","b27e6b","be8370","d7ab94","d9caa8","ddcca6","decda3","dfd0a8","e2d4af","e0d3ae","e1d3ab","e1d2a8","e2d1a8","e0d2ae","d0cfb7","b8beb7","a2adb5","98a6b4","97a8b5","99acb8","b6cbd6","9eb1bd","9aaab8","818a99","868c99","c1cbd4","c2d3da","c5d7de","a6b5be","8f98a4","8c8f98","949593","c9c9c7","dee1e3","ced8dc","9ba5aa","929ba0","919ba1","919aa1","919aa1","9099a0","d3dbe3","9ca3a9","91959a","999b9f","999b9f","97969a","979699","979599","97969b","93969e","9295a0","93959f","95959c","96979b","949498","8d8d91","939396","969698","949396","959394","959492","959291","94938e","94948c","94948c","95938c","96918a","979089","979087","9c8d7f","a59178","caae8b","d8b68a","dcbb87","e1c08b","e6c593","e8c797","e9c796",},
{"9b766e","a48378","aa8176","ad7b6c","b77b6b","cf9a82","dfc19e","ddc9a0","dac594","dfc48c","e6ca84","e9cc7c","d6c47e","c9c1a6","b1b5b9","9cacb5","99a8b3","98a8b6","9cafbd","9bafbd","bcd1de","96abb7","97a9b7","94a1af","7c8290","868b96","a4afb7","cee0e9","cfe3ec","abbcc6","919ca9","9298a3","909195","a8a9a9","dce2e4","b2bcc2","8f9aa0","909ba0","909ba1","909aa2","8f98a3","a9b1bb","d5dce3","929599","999a9f","97989e","94949c","95939c","95949c","96959c","97969c","96969f","94969f","96969e","98979b","989799","959395","8d8c8e","939294","979799","959597","959595","949493","949492","949490","94948e","94948c","94948c","95928b","97918b","978f88","978d83","9e907f","a78f74","cdaa84","d7b683","d8b782","e6c594","e8c897","e8c896",},
{"af867b","a07a72","a47e76","a78077","b27f71","bb8471","cda589","ddbe96","dfbd7c","dcb868","dfb96a","d0b983","a6a3a6","a1abba","9ba6b4","9aa3b1","9aa6b4","94a3b2","92a5b3","aec4d1","99afbc","8da2af","99abb9","8a96a1","7d838c","878d93","98a3aa","b5c5d3","caddeb","9babba","8e9aaa","929aa6","9095a0","8a8f99","c9cfd7","99a1ab","8e96a0","8f97a2","8f98a2","9099a3","8e96a3","c7cdd8","b6bac2","95979c","96979b","96979b","95969b","98979d","98959d","9e99a0","a5a1a5","b0acae","bcb8b9","c4c0c0","cdc9c5","d7d2cd","a7a19d","918c89","8c8b8a","959597","979599","969598","959396","939593","939492","939492","949492","95938e","97928b","978f88","978c86","968c84","978d83","9b8e80","a5907a","c5aa86","e3c396","e2c190","e7c48f","e6c28e",},
{"af8074","ae827a","a7817b","9f7a76","a57c71","ae8072","c9a18d","dfc6a0","e3c382","e8c475","e9c672","cdba8d","9b9ba2","98a6af","95a3ac","95a1ad","92a1ad","93a1af","94a6b4","b2c6d3","92a8b5","8ca2af","9cadba","818b92","82858b","898d8f","939aa1","9ba5b7","bac9db","8e9cad","8e9aa8","929ba6","8f98a3","87909a","a0a9b2","8f97a0","8e959f","8e96a0","9098a2","9199a3","8f97a3","d8dfe8","a0a4a7","9fa0a2","abacae","b5b6b9","c2c3c6","cfcfd0","dbdad8","e0dcd6","dfdbd3","dedad2","dedad1","ddd7cf","dbd4cd","d4cbc6","b3aca7","918d89","8a8786","8e8d8f","939397","919296","929297","929397","929395","939494","949493","959490","97938b","979188","978e87","978d87","978e85","988e81","998c7d","a28e79","c2a683","e0bb89","e4b77b","e5b672",},
{"aa7d73","ab7e76","a07d77","9d807c","a37d74","a67f75","c8a396","e7d5b2","e2c987","e7c46f","e6cb7a","c4b796","9595a0","94a1a9","95a3ab","93a0ac","95a4b1","98a7b4","93a4b3","b4c6d4","96a9b7","98abb9","95a3af","82898b","86888a","8a8c8e","8e919a","979eaf","99a7bc","8896a7","8e99a4","8f99a4","8c96a0","929ca6","929ba6","8c959e","8d949e","8e959f","8f97a1","9099a2","99a2ad","dee2e6","d4d2cc","e0dfda","e0dfdc","dfdfdf","dedede","ddddde","d7d6d7","cdcaca","c2c0be","b4b2b0","a9a6a2","9d9995","948f8c","928e89","918e89","908c8a","8c8888","8c8b8d","95969a","949599","929397","929397","939396","939496","929396","929295","949391","95938e","96918b","989088","988f87","998e83","998d80","998c7f","9f8a7c","bf9771","e4ae70","e6b167",},
{"aa7f74","ab7f77","9e7b75","9e817b","a27e77","a48279","d3b7ac","e8dabc","dec788","e5be6a","e8c97e","b6b09d","9b9fa8","8b929b","98a2ac","97a3ae","9ba7b4","98a5b3","94a4b3","b5c8d6","99afbc","9cb0be","8d9aa5","83868a","89898b","8c8b8f","908f96","9298a8","97a2b9","94a1b5","8a95a1","8c96a0","949da8","9ca6b1","8d96a2","8a939d","8b939d","8d949e","8f969e","8f96a0","a9afba","d6d7d8","cac3be","c6c0be","bdb8b9","afaeb0","a2a2a4","9a9a9c","979699","989698","979596","949393","929192","939090","928e8d","908c8a","908b89","908a8a","8d8a89","878788","96969a","969699","969699","979699","979698","979598","959498","949397","939396","949493","949391","94938e","96918a","999087","9b9183","9d9182","9c8e7e","9f8b75","c3ab87","e6ce9d",},
{"b48e86","a57d78","a27f7b","a17e7b","a2807d","ab9d96","e8e2d9","e9e3ce","e1ca92","e7c170","e1c288","a8aba3","9ba4ab","90989f","9199a2","9da7b1","9ea7b3","9ba4b4","96a4b3","b1c4d2","9db5c1","9aaebc","8895a2","84868a","8b898c","8f8b8f","8e8d94","8e93a0","939ab0","99a1b9","96a1b7","8a94a8","99a3b6","969dae","8e94a1","8b929d","8b919c","8d929c","8e949d","8f949e","bdc1cb","b7b8bb","928d8c","989596","98969a","96969a","95959b","96959a","969499","969498","959495","939292","91918f","908f8e","8f8e8c","8f8d8b","8f8c8b","8e8b8b","8c898b","878789","8e8d90","969698","979599","969599","979699","979698","979598","979598","959498","959596","959592","93938e","94928a","948f85","958d82","988e80","9e9080","a3927d","a48e75","c8b189",},
{"ac837b","a77774","9f7c7a","a5807f","b59795","d0cac3","f2f2ea","ede9d7","e2cd98","e8c574","d9be8d","a4aaa9","99a2a8","979fa7","8a939b","969fa9","a0a9b6","9ca8b6","96a4b4","acbfcd","a3b7c5","97acb9","8a99a6","87878b","8b898c","8f8c8f","8d8c93","8e919a","9395a7","9a9fb4","9aa3b9","97a1ba","95a0b5","9097a9","8c939d","8d929b","8e919b","90929c","92949c","92939b","d1d2da","a4a5a9","8c8c90","919095","929297","939298","a4a3a9","a7a6aa","979597","929091","918f90","908f8f","908e8e","908e8e","8f8e8c","8f8e8c","8e8d8b","8c8b8b","8b898c","878789","858587","909297","91939b","94959a","979699","989699","989699","979598","949495","939393","929290","91918e","928f8c","92918d","93918b","948f88","978b83","9d8d80","a5917e","a99374",},
{"b77c6a","a7786f","9f7c78","a98c89","e1d2cd","eceee8","f3f5f1","eeeadc","e0cc97","e6c570","dac291","a2a9a8","97a0a5","969fa6","939ca3","838c94","9ea7b2","9daab7","93a2b1","9fb2c0","abbecd","94a7b6","8d9eac","8d9199","8b898c","8e8c8f","8f8e92","929298","91939f","9598a8","9ba2b2","97a0b1","939cad","8c94a2","8b929b","909398","929397","929298","929399","94949b","dadadf","939396","8b8c8d","919191","909193","959698","babbbb","c7c7c5","b5b5b1","8e8d8b","8f8e8d","8f8f8f","8f8e8f","908c8d","908a8a","908c8b","8d8b8a","8d8b8c","8c898c","89878a","858489","87878d","91939a","959499","969698","969497","969497","969497","959594","939390","94938e","94938d","94928d","93918c","92918b","93918b","938f8a","92908a","969086","a29583",},
{"d0876a","a6796c","a98784","cbb9b5","f2eeeb","edf2ee","f2f5f4","ede9dd","dfcc9b","e0c07d","d5bc9b","9da4a7","949da5","939ca4","969ea7","828a93","848c97","a0acba","96a3b3","94a4b3","bbcbda","90a0b0","909ead","8e97a2","8d8e95","8a8a8e","929192","989897","98979a","9596a4","989daf","98a0b1","949dab","8c939e","8b909a","8f9198","929297","929297","929298","a1a1a7","d4d3d7","8a888b","8e8d8f","91918f","90918f","929192","939292","929191","918f90","908e8f","8f8d8f","8f8f8f","8f8e8f","8f8c8d","908a8a","908c8b","8d8b8b","8c8a8b","8b8a8b","89878a","888689","868388","8e8d92","959598","939397","919195","908f95","919095","939394","939394","949194","959292","97928e","98918b","978f88","958d85","958d84","948f84","948e84","968c85",},
{"b68166","a28276","c8b7b6","e0dfdd","e1e2e0","e1e2e0","e1e2df","d2ccc8","c1aea5","b49e98","b1a3ab","969ba4","9197a0","90979f","9298a1","878d96","7b818a","9097a2","969eab","8c95a4","a4adbc","9da5b5","8c94a4","8d95a1","8a9099","888e94","b8bcbc","cdccc5","c5b9b0","a19796","9497a0","97a0ab","9098a3","888e99","898d96","8b8c95","8d8b95","8e8c96","8e8d95","abaaaf","bbbabc","898788","8d8c8b","8e8d8b","8e8e8c","8f8e8c","8e8d8d","8e8d8e","8e8d8d","8d8c8d","8d8c8d","8d8c8e","8c8b8d","8c8b8d","8d8a8a","8d8b8b","8b898a","8b898a","89888a","888789","888688","868488","858487","8f9092","8f9091","8e8f91","8e8f91","8e8f91","8f8f90","8f8f90","8f8f8f","908f8d","918f8c","928f8b","93908a","958f88","978f88","968e87","958c86","928984",},
}

local function is_bedtime_e2(hour)
    -- local core = hour > 25 or hour < 3.5
    -- -- local first_nap = hour > 7.5 and hour < 8
    -- local second_nap = hour > 12 and hour < 12.5
    -- return core or first_nap 
    return false
end

local function is_bedtime_dc2(hour)
    local first_core = hour > 22.5 or hour < 2
    local second_core = hour > 5.75 and hour < 7.5
    local nap = hour > 12 and hour < 12.5
    return first_core or second_core or nap
end

local function is_bedtime()
    local hour = tonumber(os.date("%H")) + tonumber(os.date("%M")) / 60
    return is_bedtime_e2(hour)
end

local lock_triggered = false
local frame_count = 100
local frame_duration_ms = 100

local function make_buffer()
    local buf = vim.api.nvim_create_buf(false, true)
    -- Create a fullscreen floating window
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'win',
        width = vim.o.columns,
        height = vim.o.lines,
        row = 0,
        col = 0,
        style = 'minimal',
    })
    return buf, win
end

local timer = vim.loop.new_timer()
local function lock_ui()
    if vim.api.nvim_buf_get_name(0) ~= "" then vim.cmd("w") end
    local step = 0
    local buf, win = make_buffer()

    local ns = vim.api.nvim_create_namespace("bedtime_lock")

    local winheight = vim.o.lines
    local winwidth = vim.o.columns
    local txtheight = #hexcodes
    local txtwidth = #hexcodes[1]
    local startrow = math.floor((winheight - txtheight) / 2)
    local startcol = math.floor((winwidth - txtwidth) / 2)
    local lines = {}
    for i=1,vim.o.lines,1 do
        lines[i] = string.rep(" ", vim.o.columns)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    for row, colors in ipairs(hexcodes) do
        for col, color in ipairs(colors) do
            local c = "#"..color
            vim.api.nvim_set_hl(ns, color, { bg=c, fg=c })
            vim.api.nvim_buf_add_highlight(buf, ns, color, startrow + row - 1, startcol + col - 1, startcol + col)
        end
    end
    vim.api.nvim_set_hl(ns, "bubble", { bg="#ffffff", fg="#000000" })
    vim.api.nvim_win_set_hl_ns(win, ns)

    timer:start(0, frame_duration_ms, vim.schedule_wrap(function ()
        if step > frame_count then
            while true do
                vim.cmd("qa!")
            end
        else
            vim.api.nvim_win_set_cursor(0, {1, 0})
            if step == 30 then
                for i=5,5,1 do
                    for j=60,65,1 do
                        vim.api.nvim_buf_add_highlight(buf, ns, "bubble", startrow + i - 1, startcol + j - 1, startcol + j)
                    end
                end
            end
            if step == 32 then
                for i=4,6,1 do
                    for j=53,72,1 do
                        vim.api.nvim_buf_add_highlight(buf, ns, "bubble", startrow + i - 1, startcol + j - 1, startcol + j)
                    end
                end
            end
            if step == 34 then
                for i=3,7,1 do
                    for j=50,75,1 do
                        vim.api.nvim_buf_add_highlight(buf, ns, "bubble", startrow + i - 1, startcol + j - 1, startcol + j)
                    end
                end
            end
            local from=40
            local to=45
            local str = "ojou-sama"
            for i=1,#str do
                if step == math.floor(from + (to - from) * (i/#str)) then
                    local col = math.floor((75 - 50 - #str) / 2) + 50 + i + startcol
                    local row = startrow + 3
                    vim.api.nvim_buf_set_text(buf, row, col-1, row, col, {string.sub(str, i, i)})
                    vim.api.nvim_buf_add_highlight(buf, ns, "bubble", row, col-1, col)
                end
            end
            from = 60
            to = 65
            str = "it's time to go to bed"
            for i=1,#str do
                if step == math.floor(from + (to - from) * (i/#str)) then
                    local col = math.floor((75 - 50 - #str) / 2) + 50 + i + startcol
                    local row = startrow + 5
                    vim.api.nvim_buf_set_text(buf, row, col-1, row, col, {string.sub(str, i, i)})
                    vim.api.nvim_buf_add_highlight(buf, ns, "bubble", row, col-1, col)
                end
            end
        end
        step = step + 1
    end))
end

local function start_timer()
    timer:start(0, 60000, vim.schedule_wrap(function ()
        if is_bedtime() and not lock_triggered then
            lock_triggered = true
            lock_ui()
        end
    end))
end

local setup = function ()
    if is_bedtime() then
        lock_triggered = true
        vim.schedule(lock_ui)
    end
    start_timer()
end


return {
    setup = setup
}