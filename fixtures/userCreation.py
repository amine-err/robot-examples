import json
from faker import Faker
fake = Faker()
profile = fake.profile()

def user_creation_payload():
    value = {
        "name": profile['name'],
        "username": profile['username'],
        "email": profile['mail'],
        "address": {
            "street": fake.street_name(),
            "suite": fake.secondary_address(),
            "city": fake.city(),
            "zipcode": fake.zipcode()
        },
        "phone": profile['ssn'],
        "website": fake.url()
    }
    return value