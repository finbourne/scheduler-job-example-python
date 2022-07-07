# Import key modules from the LUSID package
#import os
import lusid as lu

# # Set the secrets path
# token = os.getenv("FBN_LUSID_ACCESS_TOKEN")
# api_url = os.getenv("FBN_LUSID_API_URL")

# # Authenticate our user and create our API client
api_factory = lu.utilities.ApiClientFactory()

instruments_api = api_factory.build(lu.InstrumentsApi)

def get_10_instruments(instruments_api):

    """
    Test function to return 10 instruments from LUSID
    returns a list of 10 [Instruments]
    """
    
    instruments = instruments_api.list_instruments(limit=10).values

    return instruments


def main():

    instruments = get_10_instruments(instruments_api)

    print(instruments)


if __name__ == "__main__":
    main()