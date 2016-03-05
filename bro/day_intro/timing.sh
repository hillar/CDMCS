#!/bin/bash
echo "# Timing" > ./timing.md
cd empty/
echo "## Emtpy" >> ../timing.md
echo "#### status" >> ../timing.md
echo "\`\`\`bash" >> ../timing.md
(time vagrant status) 1>> ../timing.md 2>> ../timing.md
echo "\`\`\`" >> ../timing.md
echo "#### up" >> ../timing.md
echo "\`\`\`bash" >> ../timing.md
(time vagrant up) 1>> ../timing.md 2>> ../timing.md
echo "\`\`\`" >> ../timing.md
echo "#### destroy" >> ../timing.md
echo "\`\`\`bash" >> ../timing.md
(time vagrant destroy -f) 1>> ../timing.md 2>> ../timing.md
echo "\`\`\`" >> ../timing.md
cd dummy/
echo "## Dummy" >> ../timing.md
echo "#### status" >> ../timing.md
echo "\`\`\`bash" >> ../timing.md
(time vagrant status) 1>> ../timing.md 2>> ../timing.md
echo "\`\`\`" >> ../timing.md
echo "#### up" >> ../timing.md
echo "\`\`\`bash" >> ../timing.md
(time vagrant up) 1>> ../timing.md 2>> ../timing.md
echo "\`\`\`" >> ../timing.md
echo "#### destroy" >> ../timing.md
echo "\`\`\`bash" >> ../timing.md
(time vagrant destroy -f) 1>> ../timing.md 2>> ../timing.md
echo "\`\`\`" >> ../timing.md
