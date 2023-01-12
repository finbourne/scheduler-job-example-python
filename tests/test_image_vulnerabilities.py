import unittest
import lusid_scheduler as ls
import warnings
from fbnsdkutilities import ApiClientFactory

class TestImageVulnerabilities(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.scheduler_factory = ApiClientFactory(ls)
        cls.images_api = cls.scheduler_factory.build(ls.ImagesApi)
        warnings.filterwarnings(action="ignore", message="unclosed", category=ResourceWarning)

    def test_image_vulnerability(self):

        image_name = "scheduler-job-example-python:latest"
        test_image = self.images_api.get_image(name=image_name)
        high_vulnerability = test_image.scan_report.summary.high
        critical_vulnerability = test_image.scan_report.summary.critical

        self.assertEqual(high_vulnerability, 0)
        self.assertEqual(critical_vulnerability, 0)
