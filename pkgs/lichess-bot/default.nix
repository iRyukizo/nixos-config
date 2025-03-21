{ fetchFromGitHub
, lib
, python312Packages
}:

python312Packages.buildPythonPackage rec {
  pname = "lichess-bot";
  version = "2025.3.16.3";


  src = fetchFromGitHub {
    owner = "lichess-bot-devs";
    repo = "lichess-bot";
    rev = "f99a4202eee5d9e08bf308ed114267a54f9b50c9";
    hash = "sha256-/Y5qARbzRP83xFw4SqpnqNUrsaBIrVNOjxeUfNCAQeI=";

  };

  propagatedBuildInputs = with python312Packages; [
    chess
    pyyaml
    requests
    backoff
    rich
  ];

  preBuild = ''
        cat > setup.py << EOF
    from setuptools import find_packages, setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

    setup(
      name='lichess-bot',
      packages=find_packages(include=['lib']),
      py_modules=['extra_game_handlers'],
      package_dir={"lib": "lib"},
      package_data={"lib": ["*.yml"]},
      include_package_data=True,
      version='${version}',
      #author='lichess-bot-devs',
      #description='lichess-bot is a free bridge between the Lichess Bot API and chess engines.',
      install_requires=install_requires,
      scripts=[ ],
      entry_points={
        # example: file some_module.py -> function main
        'console_scripts': ['lichess-bot=lib.lichess_bot:start_program']
      },
    )
    EOF
  '';

  postPatch = ''
    substituteInPlace lib/lichess_bot.py --replace '"lib/versioning.yml"' 'os.path.dirname(__file__) + "/versioning.yml"'
  '';

  meta = with lib; {
    description = "lichess-bot is a free bridge between the Lichess Bot API and chess engines.";
    license = licenses.agpl3Only;
  };
}
