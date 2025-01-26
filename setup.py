from setuptools import setup
from Cython.Build import cythonize

setup(
    name='Tamago',
    # ext_modules=cythonize(["board/go_board.py", "board/go_string.py"]),
    ext_modules=cythonize(["board/string.py", "board/pattern.py"]),
    # ext_modules=cythonize(["board/go_board.py", "board/go_string.py", "board/pattern.py"]),
)
