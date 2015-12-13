# Setting Overrides
# See readthedocs/settings/*.py for settings that need to be modified
import os

# Set this to the root domain where this RTD installation will be running
PRODUCTION_DOMAIN = os.getenv('RTD_PRODUCTION_DOMAIN', 'localhost:8000')

# Set the Slumber API host
SLUMBER_API_HOST = os.getenv('RTD_SLUMBER_API_HOST', "http://" + PRODUCTION_DOMAIN)

# Turn off email verification
ACCOUNT_EMAIL_VERIFICATION = 'none'

# Enable private Git doc repositories
ALLOW_PRIVATE_REPOS = True
