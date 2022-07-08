# Import key modules from the LUSID package
import lusid as lu


def get_10_instruments(instruments_api):

    """
    Function to return 10 instruments from LUSID
    returns a list of 10 [Instruments]
    """
    
    instruments = instruments_api.list_instruments(limit=10).values

    return instruments

def main():

    # Authentication via environment variables
    # These variables are passed into the container via the docker CLI

    api_factory = lu.utilities.ApiClientFactory()

    instruments_api = api_factory.build(lu.InstrumentsApi)

    instruments = get_10_instruments(instruments_api)

    print(instruments)


if __name__ == "__main__":
    main()