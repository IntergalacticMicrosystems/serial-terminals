# Vendored from https://github.com/theinternetftw/xyppy
# Upstream commit: bdfe173771f414538e4e2f14d03eb092dbaf20bc
# License: MIT (see LICENSE in this directory)
#
# Local modifications:
#   - term.py replaced with a shim re-exporting term_ampex
#     (the Ampex D-175 driver), so vterm/ops_impl_compat see the
#     same API but dispatch through the serial layer.
#   - ops_impl.py: save_z3/save/restore_z3/restore patched to use
#     env.save_path (fixed single slot) instead of prompting.
