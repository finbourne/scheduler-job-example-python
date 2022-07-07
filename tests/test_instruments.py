import unittest
import lusid as lu
from app.instruments import get_10_instruments

class InstrumentTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.api_factory = lu.utilities.ApiClientFactory()
        cls.instruments_api = cls.api_factory.build(lu.InstrumentsApi)
        
    def test_get_instruments(self):

        instruments = get_10_instruments(self.instruments_api)
        
        self.assertEqual(len(instruments), 10)