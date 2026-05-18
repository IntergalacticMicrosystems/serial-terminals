# Shim — upstream xyppy.term replaced. All references to xyppy.term
# inside vterm.py / ops_impl_compat.py / zenv.py resolve here, which
# re-exports our Ampex D-175 driver.
from term_ampex import *  # noqa: F401,F403
