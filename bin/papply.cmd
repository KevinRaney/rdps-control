set base_dir="C:\control"
set manifest="C:\control\manifests\site.pp"

puppet apply -t --environmentpath "C:\" --environment "control" --detailed-exitcodes %manifest%


