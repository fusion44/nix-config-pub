
# create all folders
mkdir -p ~/dev/blitz/
mkdir -p ~/dev/lnbits/
mkdir -p ~/dev/stuff/

# LNbits
git clone git@github.com:lnbits/lnbits-legend.git ~/dev/lnbits/legend
echo "lnbits" >> ~/dev/lnbits/legend/.wakatime-project

git clone git@github.com:lnbits/legend-regtest-enviroment.git ~/dev/lnbits/regtest
echo "lnbits" >> ~/dev/lnbits/regtest/.wakatime-project
git clone git@github.com:fusion44/regtest_gui.git ~/dev/lnbits/regtest_gui

# Blitz
git clone git@github.com:raspiblitz/raspiblitz.git ~/dev/blitz/blitz
echo "raspiblitz" >> ~/dev/blitz/blitz/.wakatime-project

git clone --bare git@github.com:fusion44/blitz_api.git ~/dev/blitz/api

git clone --bare git@github.com:fusion44/blitz_gui.git ~/dev/blitz/gui

git clone --bare git@github.com:fusion44/jaspr.git ~/dev/stuff/jaspr
echo "jaspr" >> ~/dev/stuff/jaspr/.wakatime-project
