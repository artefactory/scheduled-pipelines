This markdown file contains more details about the generated repository and its features.

It can be deleted when not necessary.

# Features included in this template

## Eased installation

This template repository comes with a Makefile that allows you to easily install the required packages and pre-commit hooks in a virtual environment (either with [conda](https://docs.conda.io/en/latest/) or [venv](https://docs.python.org/3/library/venv.html)).
To do so, simply run the following command:

```bash
make install
```

By default, this command will create a conda environment named "`scheduled-pipelines`" and install the required packages in it.
If you want to use a venv instead, you can run:

```bash
make install USE_CONDA=false
```

## Eased collaboration on git

1. This template repository comes with a [pre-commit](https://pre-commit.com/) [configuration file](.pre-commit-config.yaml) that allows you to automatically clean your code when doing a commit, namely:

- format your code with [black](https://black.readthedocs.io/en/stable/)

- sort your imports with [isort](https://pycqa.github.io/isort/)

- lint your code with [ruff](https://beta.ruff.rs/docs/)

- check for security issues with [bandit](https://bandit.readthedocs.io/en/latest/)

- strip the output of your notebooks with [nbstripout](https://github.com/kynan/nbstripout)

- run tests with [pytest](https://docs.pytest.org/en/7.3.x/) (on push only). To go further, you can also use [pytest-cov](https://pytest-cov.readthedocs.io/en/latest/) to check that your tests cover a minimum percentage of your code.

- [other cleaners](https://github.com/pre-commit/pre-commit-hooks) (e.g. trailing whitespaces, end of file newline, etc...)

2. Moreover, a CI pipeline is automatically triggered on push to check that your code is clean (it runs the pre-commits again) and that your tests pass.

3. A [pull request template](.github/PULL_REQUEST_TEMPLATE.md) is also included in this template repository to help you write better pull requests.

## Eased documentation

This template repository comes with a [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) [configuration file](mkdocs.yaml) that allows you to easily generate a nice documentation website for your project (and deploy it on Github pages).

## Eased development

This template repository comes with a `pyproject.toml` file that allows you to easily install the repository code in editable mode. It also enables to setup the different tools used in this repository (e.g. black, isort, ruff, etc...)
