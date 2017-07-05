# The path to the project root directory
ROOT_DIR = '/opt/probe-website/'

# The path to the the database file. Needs to touched before starting web server
# Absolute paths must be prefixed with sqlite:////
# (Relative paths use sqlite:///)
DATABASE_URL = 'sqlite:////opt/probe-website/wifi-probe.db'

# This doesn't need to be changed
ANSIBLE_PATH = ROOT_DIR + '/ansible-probes/'
CERTIFICATE_DIR = ROOT_DIR + '/ansible-probes/certs/'
ALLOWED_CERT_EXTENSIONS = set(['cer', 'cert', 'ca', 'pem'])
PROBE_ASSOCIATION_PERIOD = 40*60  # In seconds, i.e. 20*60 = 20 minutes
