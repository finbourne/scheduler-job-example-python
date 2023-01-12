import unittest
import lusid as lu
import warnings
from app.instruments import get_10_instruments

class InstrumentTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.api_factory = lu.utilities.ApiClientFactory()
        cls.instruments_api = cls.api_factory.build(lu.InstrumentsApi)
        warnings.filterwarnings(action="ignore", message="unclosed", category=ResourceWarning)
        
    def test_get_instruments(self):

        instruments = get_10_instruments(self.instruments_api)
        self.assertEqual(len(instruments), 10)