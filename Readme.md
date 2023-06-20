# Robot framework examples

This is a How-To configure and setup robot framework for using this example tests.

## Install required packages

Make sure you have installed Python, pip and virtualenv

## Setup virtual environment

```
# Create the virtual environment
python3 -m venv .venv
# Activate the virtual environment
source .venv/bin/activate
```

## Install Robot and dependencies

```
# installing robot framework
pip install robotframework
# installing json library for json manipulation
pip install robotframework-jsonlibrary
# install faker library for fake data
pip install Faker
```

If you are using robocorp extension manually installing modules and libraries isn't necessary as they are installed automatically from conda.yaml file.
