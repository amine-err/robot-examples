# Robot framework examples

This is a set of Robot framework test examples on the jsonplaceholder api.
You'll find all the test scenarios in the tasks.robot file, it includes requests for GET, POST, PATCH, PUT and DELETE.
The test file also includes examples for using JSON files ( found in fixtures folder ) as input data for requests.

You'll find bellow a How-To configure and setup robot framework for using this example tests.

## Install required packages

Make sure you have installed Python, pip and virtualenv

## Setup virtual environment

Clone this repo and inside of its folder run the following:

```
# Create the virtual environment
python3 -m venv .venv
# Activate the virtual environment
source .venv/bin/activate
```

## Install Robot and dependencies

```
# installing pipenv for dependencies management
pip install pipenv
# installing libraries from the Pipfile
pipenv install
```

## Run the test file

```
# run test file inside venv
pipenv run robot tasks.robot
```
