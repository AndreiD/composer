ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.10.0
docker tag hyperledger/composer-playground:0.10.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��oY �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�l4g�h,��acQ�y�j�VpmG� x�Xr_�o�[���>�l��w�6�MQ6����]���	k����Yաu��=�;�%�jOn���Є��mhEF��"��a9�W% !����0���$�}�2�ԝR�T8,U��Y�T�䲻�g?���_ �Mؒ]�I�u��2Z��]@w��ܰT��1XB�F�n�N(9����H�X�O��X�������2��af�������lv�Vq�`E:F�G<��b�&IU��9m�=h�� �03��Մb��n*̌)�Z&�m��n$���gjӴg��)z5��a��#��"���6J����f.�1KV�-Tg1y�\^��qѯ�a�0M??S_�攙���9&\i�-��m�V���̥w�yH-���b�:�K�uS�դ�r%Q;Dԉ͞JĨX��*Rzvj��a�ɢ���V�h%_�x�^8��em��&5ߙ�K}j~�F<Ԅ�V��#�^��q���x��E�h��я'@xpJ����ϙ�V����;�m�̿p����矍�x!.ph��<�m�u���"U�4d�Cنk)��_ �I�4U�<��cR��UJ�rJz�|���K|�=0M�+r�2Z������s��>��O*�\l#�뀍��0G�MY��|��6�i����?,���c9�����G7��Z o����Yf [,�wa&̄/uڷ5Z�B�l� ����<�p�z�8?@˰ж�5��nd�0]o�|LK���ѱ\H�d��֔S���T�6鑈��C��хC��k^��f(]�#�]����+���.�x����	u�mUԱ���ji���;Y��Z3$[JG�\��j&���`a��"8I=��@z��Հk�k4����$5ԾT�,6̏�H^z?'1�3*�J��7抺�(�/n�����&_�k.��8_�sL����Ρ5A���u@����l偖��8p:����em��ч(��uUo_��q!�1�/��u��=�$,L�~}I�-�[��,� ��4>��U�HA�c � ���Q���� |��"�a#��i�e�@�$5S-5�M6.[�nl��;9j~�f� �P�{�G13@#8j�+�d �b<b
��k�}�&�m1�^��V1���
2hƝ�d>�w`��y�8G"3oU�<��}�/i�V����6$_���>������ю6G������\�!�0�M�:4PuX��ч�ml�A����t�A,�3�)什��0'�����?���1�qc�Kʯh�U���W���qz����&���3z���D�^а��}��q��1�74�g��P?ڲB5n��/�������au�2�������l�#��s�@m,�������n����NJ_�_<���l����iS�c����v�����4ײpHk �ǰ�T:W޻�:�����Y%U�V���t�1��|ˮ���� _mc����DVnFL�s���T��J�WW�f�o�N  ��nC�Gd��n7�E� ��&��:�lxs��F��~>����;�Yz+U�\=��
R�V���	�y��xaC4YM��L&Jﱂ�lZpo���P�ë�$*�x�<������s��xKB��I�Ed��@w{h������,,.��dAG�t�V�d���舯�|g]��f�BOr��,bs���v���ȸ��+��l�������a��O���� .��=e�Ņ�F��/�Գ�Z}�t�TM���Pȴ`K� �uU<&�_�7Z��0G������z�g������u����;&�,�����?����������/���0��ᢂ�������Jxn�hn���eX?�Ru�� ���z�Sx����?�;;�P����/{��ٯ��7�s����QC����yFj�X�Lf�Ӎ�c��*e0A��d���Vm��hP�Q��K,�^����az��1٣�5�>�F��(�BV�=x�k��#��X䇹�O� ���_^���P��Y��n�?�����G����m�Ȟ�j2	@����^��H� �{���z�b/vbg1>Ą�03*��Z����w��,/�w�,�p��E�䟋o���*���n�j̣W�*����%1]�½��m,��ga��/D7�?��=�#�I�>t\s�ʇ�#V�KX^���YpQ�Gt�����/���V��y���8���u�#*�^� d�H����' �2��UɿF!��(��N���	��!vG5+�U;��ph�"k�v�w��+Bn�
"�z컍[p�#ܩ+d��/��[���4cx,�NU�N�E���"U�]�dQ&E]QhLGA���e�G#��6h@���s�MG�ȷ"]�_P��C�*��is{�6�,��?q6���� _!Y}_r3�/���;�B`k*����K��qL�s�.Z�
I�\)�Sg)�LD�IE1���{��' T�dn'k�y1䮩�@
K4e0��)\0%J4��<�C U*Kg��T>��T���j)-U�T��D�PO҇�\�������lE,W��(l�?�"�R6�+f��R]�便d-;�p.��Fd&�� w&��;Ą�fO�\��j���2�)U+�'�xB��ϣ�`���T����?�Ru�081{��k6�[S��x�'Xm̀v��mk�@x0� �hB�\2�御�=8�g���K��B������aA��|lZ�3������g��#v���#_ɝ�y�]��wTK�	B!rj���|����j�l�~t�l������%>�<���:��X�n��ۋ����x9�g��d���������<>,;���n���a����Fv������߻�������ų��J_�o		Q'z���-�#��a/�}���jl�N����������]#p[�ʧ��|
XV���R���?���y���-�����	��^�Qx�o�ZT@�WCW��_��Q�j���i6&��i�����\
�H�g�����������!Hn���c"����m��/!�hY��ϡ����������s��-p_�����"�Xs����j�4��;�� �M��8��R�b��5xc��b�v�+/��0fa���ܷ`>z����b���ue����x0�"�U����L�-2�ٔ�Q�"s�H�
��!��]B+>qs��6�g|H4�o���8}n���������C����8+l��뀕��Z�y�)�\,jcQ���O���������k����������������<�����6���NKa�OȭF�Wv�X���x..C��|�O4Q^����H�����5va������+j���ֿQMSS������[���/o[O�}NQ)C��Q��ֿn��5ZĮӿ����.'��~��DE�����a��_����آF����(�ǖ� �����S��O��W����@����_�rD~�Y�V�b�����?�l��z���?~�o�6�nv�y!���k���+���x��6Q�x�A[y���H�-�Pe���B�k8X�8ө��G�V���#g�PX����F�Q�;Qf����-�o�(	���(+�v�2� �Pdv'.'l\�2�85��k�H+��^pwB�R6W)�\�er)�*���z!�Ke�S)QI��A.)�se���z�հIf��۸jH]�h�j������9#!܁r)�Qb7+�5)�)���t)���bUUMu��FV�5�o\�X�Ȝ�5/O���(OMf��J/�p��	�s���o=�*e��K�=}��4�&�ӊp������({8���;��|o.�`��UeP<�q�j�)Us�1N;'i�(��~|�l��A��$]?:�J�7�ڥT-��ýK%G\Ɩ�O�JO0O��q!y����P|�׸���N�'�¹��x޸�Z�$C0�������ǂ��B/Tf3�����b�QM���L����J�O�m)�J��Ҿ���d��9�H���E�Z��~��V=98>�X��q��&������V��N�� #7+�*��Ss��)V�9��<,�Nyi�mΫ�d� �h.���@JFGx���i���z�\H��I<�B�ƽj�G�B�@�%{֩�Ɠ�d�n����A�W��$ '�J���
*�F�G\�Dc�34�)�i�����x��(�^OI�_���ȗ	�8�觯�� +�qmPO�S�H;׮1�W|3lC2e)7($�n���^�?�u���~�X+�{�u��R1=G諫�p$�%o����?V\k@���~�/�zwC�m�ecL�	�?=0���a8��-���������~��S�}k��������(�
��k���tX���� ����*��hMo[��Yf c���0�A>�<0�HB�6bO�ӒXg*�[X�kZ_ˤ�rY>8�9��L��(��~�>��f�ֽ�ȩ���:�Kiƫl?��z�6<*C!�A�V��j;�9�k��VK�dE��k�0�ޯ2����QH=��+�l�>��>�y�����/l��u�'[��Ƨ���|�?7g��7��������R��?�H��}����Ʈ��x���ڢ$���I��j�M���Fl�i��a/��2J��L�+A�-��u�r�c�Q7ك�|��ѝ�.ؼ�.�ľ���99-�����4e�z�~?p����KZj;<���`�������!������a-=�Kп,3DMe�f�2$|�S�p,�a�m(ｯ�|�-Z�`��r�Ax1�p�j�K^R�j�4�4l��J"����u��8�mГu����șo��I
ЃO�?l�>��G�;�r�Z  m�dU���*���m��	2���G4�fHV5t <0�H�RF7R���a;:�w��G�]����<4�(y,�m��ʼ��kΝ|l�}��k:��q�N��t5~I�rC���\8�Au��YG&�pV04\˯�[�]��U�>9��8p~���]M�+G^O�Q:!����a��6y/�7v�ۣ}R��m�=n��csU�����w�m{��p�]��E�� !��@H���		�
���
r���@U����Ǜy��G�gW��_U���GU��
�x�����HQ���򹣍�n6�1F$�L��a������7}�*m��65T%Hj�	]�.����Ƒ��r>����	)�����Q��s�#ӽ�u�A�O��9c�q��?�uA��f��C�4`�3�d|���p��=+��1�=��s�w�uƇk�����x��� �rF���{W2q�&���X>���S�����ʠ6����K8Ar����(����/�mh��f���iC�S��S.��:M	�8���u"H	��5�����2���e|�� ��*I`rI��������g_`hgث����B�14&�kJ�� za��1rY_����\��0�6P����='W��1YO)oص�)t~��^�Z:7�bOH>ƙ�|�l Gr���G�2'�#B����f��?E�KE�ɚL�����c�����`ـ���F�%�1�H0�R��Ԛ"�@��է&�"h+�v`+�dX}��kҝ��Q�@U'��x;��vYR�p�ТC�"�2�rm��+�5t]3�{9⚍#�n;tnlt����L�	+��֭�/sz�~�Q7=)�ar��4�����ߕ��6B�o%A�����)��@�������16�T#�܍�f}{������6$������S�X$�1�OF���z%bo�����o%~����/����:'������_��'6���'���R�oS�oRĂ�՝��}�����X�юl|&�&�E<�Kd䨤�{qYIĒ�x<.�b�^&���{1�J� ��{;��g�$̐PzJ\NK��n�ß������d���=����o��?����Wf�"��#�_�������������t�����=\ဿ�p�?�@_�z���z�z��oa5ڎ#`�� c����آT���}K/f
J�<k�K1�z��U��K�1K�"n����UD `�����/Զ����k.��(7%��JΎ��K:*����Y-!�u L[8i5?�
�<����-���(��s��s��m����0���z_�����8�a�j}T�K��-τ���٘���3���yixo�([�7��h�궝W1Kp��Y���Nx��jbP�v�Ͱ�����G�3�K��p)lr��e����yD-�r�o�c����U��V��?���2�+�Թ=S��f&���r�EլG�t�fh��j~(�i+B�t;O09�Y�qӦ�lI�1��x��恥��LN-D-n*���|Ht�	�oē�b,J�Ѡ���7a�l��Ӽ�]L��z��bڀS��g�zb�����ɾ:�gM�˶�G�����'z��H�Y�Ѵ�t~��gc))V��`rď�#j=!}l6«������j�]���]ї�]���]���]���]���]���]q��]a��]Q��]A��6�����K��(���[�o"Y���`�����7;�z�9[R�r������ۉ������-9?_�����(Q(�o�z�{n�z�v@ ���;�p;�Cx���[V��Q��O��9-�w�r��R����-�Y�72�Bt KrԌ
'EZ;'"Z�O�sM��m]�TO&T���%j������q?��A���t&D�ɕg˓J���
�ϖ6�M�|Ҏ�k����Df�L�"�\.�T�a<�&��4Y;7j�Ԍ�HĬb�J�<}RJ�3V/Q��W���d�ӬL�UB��X��z��,�rWhٮ�7k/�ڿ���/��z�	��}c�ݷ�n.7���v��0G��[v��Ʊ/��Yg#\�����j�Zw�4���7B;��Ga�.쾲	��.{��-�N���˛�7B���,[�G�PmqR�7�~�M"�+����#7|����y���9J��kMYi	M�V>��ҳ�hjL�i-�\�~��{�>�/���X����ltS�v�1,,g'��c�E�&j���,q��9h��t�lNuM�mmZ��iz���o0B!P��i�Q��������F��ZL����r��4�M��qUɝՈL�o͎�̐*W�^j��a��ю��$�JJ��mkމ�f��Z�sEU���c�J�ĉHW+��>�e��,���f�6���,]��H#cZY<dV�iL��jV5����g��S)�sh����k�ͷK��Xs�j�@�Gk�v�,Փ�D���pxLED�$�T`�FR�fM�K� D��>��5�G���H��ue�3�Z�Y1���O|�?�*���k�&�e��k�b��Ú0-��t�b��~}y���_��o
����f��[��^���}�?�V1�V�b�^�ϸE�,ʺ�x'�����3��;q[}�ԝ�1��v���@j��Z�f.�N!����L�L���Z3��R5�Λ�|�ak�QC)�����Vk���27`�S/)VǮ;
N��k|����� �)��F��\8s�Wh���@�s�@����,gL�f����s!a��j�Ws��L�{��T�~�tBW%�L�?V���p�U7 �z����uO�U%�9V���@l�c��H͊����w�0��E�0*+���B�7�4�Kѽ�ha[\#ӧ����Z�H��g/�յ:Q�#Y��P�k�щ��
T�)�}.D%�ľZGb�y�u$�?��m�`����	q�%ϙ�8�Jg�t�s&u�{��y�w(��(Vkw���}3�7�QM�!��p��`�eM�׊�g�Z�W��r_S@�3�v9�`�UN�ͦq����ez:ӈ��?A���<���j���yl�����6P��9�kjq.��gJt�e'� ą��ay}��D�%��f(5^LԤ��J��-�#�''�y����M(��؇3LFk�c7���%[`�s���t�0�b��meV�pW)���V����G0�ĥ��	�n�L^�{�LQ?ؼq?��x�V�/:g���I�5=��_&��j]1���8���B�Z�UF��c%�~�-�M���d��y\FC[*����w�����K��/�$�6쭤�h㠇 �'�GEh<Y|�yЄO���^�]��+.������0��H�uՀD�!
�	�d�m}J�"����-�t�E��?��O�ﻝC��D1M�%B�ć.�)�6�u�\�I�=�Ke�x����ϭ?�x���D��f�_����_$�p�C<���߫������_��Oz7M�������)���5��wʝ�A�B*��|��Cb�&�.:LƬ�I��*��vUA<CGž�vywg�l�ؼ�}um���J@��|���}�:�
s��D���%�?[-��O�Y׳\|�z��5%���@N���_�T�pK�>Y� �-�	<��x`E�kP7H��z=�1.����B��?�:�����ba�078�'
�ԅڀ=�]v*zC}C�.��60"a�HNM�2Z���NH��H�oLu�)�g�F!`��O��/OyIS˳��|�V��*�0	 �L�>�O���Ǥ;~��E5v�+s�i�DW��6�!l,|�x��zg�n�18p��g��*�Ƴ�t��0W$� ��F=��, Q���jۊM�s]�X}�i��ۦ_����9�ɵMCaï�j0��fxh����+B'��
LaL��ы�Ir+#���Du�1�ɺ9:�L�NU���݉�˭;�c ��Xٔ�&���wo޼��1Ѩ�7&h�����8�h��y�6��?h �:��7�L��g=���6��VOG����!:]l*FO��5F.�u���wo$�y���[h���Z�� �q+"���j $%:���<��Jy��Z_����F|>6��O��xd'�1����-��%k��ٺ
����8��o�}��:
7�D+�ӫ B�+HK�����=�h���t��{h�acz��7 ��-�)�8e����u��ͺ���e�]+q��前LF������3<�6r���P^�'��rHF�u�h��Y#kb���z��o��ܰf�!�;x��X�(`N
N� fv��p:�V d;V&C����70w�y �H�4Z�r�Bߎ�e�#+/�b��B'�����@d땉t�,yU�U�V&�-���I��]G_hc�F�����^?���a�7A�z[�q:f�+5����p�B�	�[c�Vm'�J~cWIPQ�ȕ�ғ�@��� � +�k&ט���x�c`��=��0*WD��I�z�n�F@����+k�LS��M�:�D2ѕ�n�sC#��ڿ�TY�h���ҐODPpc��&����#Ų������K7�n ��^�+ ��j�Ap�H~�mFx_�l�;�U�������;q�-����T4���-u��}��+���
�i�S�@C@�:Qɖ;7[�/Z;��]i�:0�Ym���L�Ϟf�St5Ƴ�bu�[���rK�W?���[��,�Ԗ���\��Y�/ݠ�մu��St���X���#��b�hT�X")E��LT��K���^���(9գ �J1�&*K=��I�x<��h��ǒ!��ݾ��Xq�Y�i�e>0,�O�䧛�qB^�)L9@Mŗ�ܸ[:���s�,^�%�R2$I��ӑ�d*�Ļ� $�񌒊��i%$�!bP��O)H
�|*9 �c�|*��1���P	�� ��.޴5n����:嶍bH�mb�5��kTv�탗�m��ru8��\��ӥ�R%_⎹�3Y����d|C��4�ֹF�Y�W�K�ѿ�!pb��>Ë�אn�/o���-kW4*K��F�g�Ȯ�Fw]]���{�]xe�@��Ne�>6�VX5��Z؜têf��L;k]k�#*�h:�4:3�-#��ǩ'�5�\��.�
o�H Kݔ,}����r��c�����l�ΡQ�����*��7F:~�-�|9[aW��R��̯��\��V���l:���pm���$<������P�~
��HAZO�.'^]ڬ[����JC�V�9>Z��V�~$��=���4�ow��5�q�$/�T�{��U�זU'pl�m���9YZ���=ˢ�PY�
�l��-���&����we�ik��]��S��y�U_է	 �b��)M�y�@������Ďo�ĽR.BLЖ�^ݻ{��z��I"�[��/�-_v��+��x��m����4��3L}�H��c׹c?z���D���=���{�5=[�������?�jer�W�u��Q���Q��׳��ٶ/�xK\���_?���|swZ�%�܀_��;|�)�����3�ϻ���"�������_>����us`.A�+�Ф@�������/(����}@�|�+���O�&X���C�oY��iX�����n��I��F����y�o
@ ����i�$���i�|������T����'E_�OT����_���[��w$ ������j?S�#�K�B�qw���CT�/�$��bR$G�Qg�`)2
FƑJ�H�1/��	N`�「b�������������n���B�o���1��<�3��e6Y��nyW��^w�)�L/����k1�a����?M��+e���G=H�H����eb���=��ۍ��N��p�w���O�C8S[�>�n�^g;���CJ�~�O��x]�k?���g������������'�>P��[��� ����i�N���GT����������?�������
��K�vї�S���p������$�������B ���?��������� ^���/T��*��Y�'K�7�O����N��	s:���w�Gݩ���$�@��>����ϭ������0��- 8��u��IQ���K�}���ŗ�O��Ƣ薲y]��\:us���TH�gh*�������xO���5¬�o����~o������XV��o��|j�$f6M�CEg��d�������q�YNu����f�N�)�Ɔ����<��J�n�;��, ƧJ��;�&��Վ˟�ȍ���>��>�_�����|#�zR�3}ו7�fAxu.�X~o�ձ9\�F����aߧz�N�sw�)C_Ǒ8H�;�&M�ߖ�5��Q�O��.Q��`������u��R�����l�0�qW'�)�R���%��p�_0��QH��?��Â����0�����X��w��(������O���O���w��0��$���� ����X��ý�=�s��(��������//��w���5����>f�{>i�����W��}���?�����M��a=���~�]s�BI���q�Q�f�	2{�YA�\E�M���Z�B���MC1��RO�&.7�>?b[Ce��Щ.;�e�zz����X6����=�)�y�!��*��+��c|��������vlc,7�	];�D����~Z���2�V�r8��Ca�X�b��Y%y"����wG��*JO<���I����42$��qҪg������_������?
�
`��f�1�V��� ����8�?��^����?����(��p�QQH�Tĉ\���IR�1���b2<��BH3AH2!r��dL�_����4������5����j�+e�'�U*�'�^�R���i�l���>��ۢ9�=��}��q��7ܣ��Q�J�Mo;��>\�Ƌ%��VВ4�'��6�d���`]N���햝��G5��-p�����8��gs8�-8���,��
��������/�'��_q����β����~"$��:#^^K�;kn�p9��i�9q��=�z��[zOM���[ǔ�Kk�^��SyL�rg���c�YBv����+��9��<Wj�]���9��a�o�2�`���� �{-���i������'�����O �_��U�������� �����h�"�����w�����%����/����6�����y�(}��7��Ѵ���=��W���8���{f ��1��V�ޝp��a�7��]�J\� �8@����qr���VL�Z�3r�mGD�T)+�zn4+˩�h��z
�RbuzM�1���$pV���z�%����T���b�xaN$�}G���ǯp���~_�2�v+Jn*�x`�$zE9�OB��b`@���Z9IڱU��-�S����iA$�(Z��R�u��&�=6��ZY*so`����V	e����I�l�j����֕���P)���2�G��\+~����u:m5�2��r�Zݣ���<[����6f_̓�bQ��q֭76#�F����,�?���?���_�X����������p���s���H�����[���_���� ������/��������D�Q��Ɋ��E�lH����<�J�@��3~]�A�MG��BL��Cc����N�/'�����_��f'c�r�����7	�^OV���ck�cO�e�+�����։�>:Ή����Q��ݦ&�Ky�X.���,���E���n-��O�.;W<}�wv5�ui��ߪ�U���,*P��Z��S��?��A������C���#�X�7��y���?
`���M������b�8���h������!r��/?���1*��U�wZ��
���~9�կ��֮��Y�cTV���@����ܾ��O��k��T���֘xO���5�=�ߗ�l⧵�y޷����s���j�#^������A�����t�ު���d��O����D�ӭ+�es��	�;��Q�#g2�L��u���#��;����j�7�ݮ�4e�J\�r����������b��;A1��v����جN~��%�
oN�:Wc}w[��Ȧ��i��	UO6Aw�����T/���\�,�nޓ�jTN����jaՏѪ��׾n�$�b�3km��UV���vd�˲��wV{0�� ��0�W@�����^v�-h�
�q����o��?$��o����o��������y
) ,����8�?������ � �����/�A����������Ş����&A���������K�����@��o����� ��I�6�g��Q ��/��m�h ����0��(��`Q0������N��$�����@ ����ܝ�/P��x�?�C�*��U��� �������w�G����0��R  ������n�?��#�����C�����$ �� ������?0�(�n�����a����5�����?0����� ��� ����w��?"�/�$P�_ ������7�����X�?��#�?����������C�w�G���?�@���c���1�� ��ϭ�p��ٽ ��'�����X��
"C�#Q�G!����L�P/F>�y"�)Q�|_�Y��M?��{��3<�A�&�ow��9���>|����s�)�,U�d�_r�����7�Jc5)K�Y�^K�5��j>��+Z�:{I���Re��ݫ��Z����N_J��P�R'ۛ�G����<��^��Nu�_��ծۢc����M��%�E��㕩~�n�T�3����gq(x���p�[(p��!�+X�?�����s�9��E_�O����;�vȘܡ���y��l�����jmڎN���_V��!;�k}�?��x�9;gn��l�ԥ�۱M�;��$a�־���P16ew�S�m�zׇ��ioL��b�u9�I�a��r����k���3�򿈀�����ۿ���	�������A��A��@���X����^�����%�׺��U��?���1j_��Kg`�ӽ�$��/���w�mw�v��)^�Z��:�x���n��ٺ�K�~&mx֩�AB�(���`ӟ�4
;NcOU�I�';)�o���1���I��Z�q�L�5{b;��o�fu��ڮ�<^���u��K���V��T���VI�r���S�$^lhѾ\+'I;�����"uʶ�X9-C	k�b�Vj�n#�meS�U�&w#i��HS�`0122����C�����N*U�3�!O�3�j)5��AE�l��"I�Wɺ6�J�n��ʣ�6���^�w��j���[���x��/M
�_��h8�E��X���_������?��Q��O��F��~���nP�-P����?KR$�?
���4Iݞ����(���|=��?�������g��!��/����������i��z9�;���f4���.����Q�d���C������C�M;�����9�ֹf5�������xJ�_s~v�'�g�y�<u�J��\R����ŵ��ֶ�ߕ�J>fZ�k��T��RP�ԗ����.���i�D�k��]��Ur���T�iq�َ�����]S�\���U攬IY��uW�q�����~B���vE���+��h�k*�}�Oǹ���J2�/?˚�~J��7w�/ٵ��^�HK쉢*��v7LI�7�S��T']�vRߗk6W���!Զ��g�Z�Y�9�j����D��͉#*T��9;8�(.��e�+ҡ-�;���Z9��H��[���9ɝ�rS��}"=����c��¾䴴yK�{�~O�B�q7�p��h��pd�S�#�bi_1!�_f�P�,M��h
,#�|F���8�(?&C*�����m��Y�A�����OFr��vF{��нh;��?���C��9c�cO���o�ʷj�x�\����->���$�p��]�����x��(�����C�?d�0��1�����q�����_�t���_�F&�[�t�����҅΀�F�M������y屠NϹk��`#ޖ��})�#ޓ�����W����>��ZOy���񺼟�L2�f+'�Rv����]i��ؖ�ί��U�x��2hGWG ��<ttd 2� �ZQ���zͼ�Z�YYy�J���H/ �Q�Y���ס�r��⪏��9=4�5�t]L�捲�b��Ӵu��]��C_���dê9=�\Q��W&���~�a?�θ��	g��X�rر)��I�a"U��X�:��sq����<_��&r܏uf�iݛI>�Ǯ;���1c�����(Fih?t��XG��Y�Zw�ca�n��y�Mn���൦�J!Q]no�hp�{���]Q�G������L�A�O��N�]��XŬD:���+�1S�(W�jK��.XVq�P	�J���Z��Y|�~���������=�����n�EJm{#�X�ƦY>��0��qW�������2����%U-ȷ���Z����~��C�0������w��0�Y ��_Mka��B��?o�����1�_l `:�0Ȋ��p������L��>��>��؟+�,��~{�j	�V7�����������6'_�Z���(���u�Ǻ۱�&
ȇ	"���GB�]��:+�ԩ�O��6�&_��?l�'+�u��B�u��:s�</]�b�/����Z�n�}��,���>g�r^-�Й���`��^�G̥p��L����N-��N�ӳ���7h�"��N��/�X���5���p��t�Bx���`�l|Y�Q���ȷY6n^�}Vߏ�-kM�c��Z�)[b�x�6��L�]���n!7�������U�09�/�l[�7�Y�gH���4���x�ʐ9(W1��Uw���8#�a����J�\�G�ԽS	Ú��ǈߧ�U��#�7�eA��������L�E�����?��+���O�!K��D����m�'C@�w&��O����O�����o��?׀�@!��c�"�?��燌���
�B��7�o�n������o���o����-����_y�%����������?����w������M�?��?���'��3A^����}� �������o�?`����'��/D� ��ϝ��;����Y� ��9!+��s������� ����(�����B�G&�S�AQH������_!��r�� ���!������C�����	������`��_��|!������
��0��
����
���?$���� ������!���;�0��	���cA�΀����_!����� �_�����y��?���������\B�a4���<���8��60 ���?��+�W�������&p���*��T�F���a���.�J�2�j�:I릩��dEXc*4FS�÷����(�W����������7�'IXTj
�k�/5XK`�\[�N;i�&k��Ͽ���'a�����M�]�>�+X];��9�Z��~�`jj�p��?���m���M��Gm��v���e�����]X�K�5�፥Bb��
7�PZ{��Y�Ѹ�I�2����ZU�<�����|��nn*�/�����g~ȫ��60�[����/?��!�'?����|J���[�qQ���/?|���S�6!��A���3Cb�Y�k�L�em�]��G�jo͇���)L��e�;Z��l�Nt]|6r)�#	q��æR�=�iTtt�4�KE�Dju���r�R���$�R`�->T����ע��sB����>���ب#"��r�A��A������i�4`�(�����W�A�e�/��=��G���XQ ���Ufy�H7d�N�����>^b�����ښ�Lr��ېףm,&�\{;��)���Et�ۍ�v�j�eW�fe���iyf���	1s���[��H��0s{ML��F]�����հyz��\iun�fɋ:����_��l���Y����k��D��ן��9��Ǎ�{���Zpt)"��D����mA��������C^i>9�|"�,Ξ�gx8ޗt�}0k�Juk�m]�>g�֑[��H�Y���alr_L���c�NHM�i:���vG�t~x��E�8�Oy���� ٣�������v��QaR�O��x{���;�_�Ȍ�_^����>! �����v��)�����Z�w<8����s��N���d�����"�y��#��?w�'��@�o&(��d�Ȋ����c���d��G�|\B��w�A�e���� �+ �l�W���rCa���������_�?2��?�i�����C����(t�7=uf0���~S�������c��R�Sϵia�m����ڏ�Ð�R���~ _Q�;ks�k�o�Z�{�@���_q�a�ϝq���i�V�u�g��>R�{���\�\��u1Y�7ʎ��N��i�w5C})������<sE�rd_��e�ȷ��^�~�;u��&�]�cQ�aǦT�'e��Ti�ce�x����֞��|}f����_֙�uo&i�����Fƌ!׳.��,���~�Ǳ�4��������~��Q�������kM�B������$3��q
��`�?7��^-�w[<" �l�W�����P$�~	� �����/��3������W��?	�?9!w��q��!��c�B�?������#` �Q����s×��z=�������fÎؑ�IՉұF��������>�ǒu��tw�����Z��G5 ��j ��p'����yM���U���(�le1�ö��;��Ҙ��QD��*^?i�p`�+%t�ب�qw��UM�Z��k ����  i�� b6��5mn�vM��>.��z�ZچD{
��1��(�bX;x�V����Qa��Hñ҈ܡ؃*�V:j�!ah4]����Ě���a�7������e���߇E��n�������������c�?�����j�1MZ��ZU5�L#L
�hR�)�$�Z3(\71��L�����Z�!�4�>|��"����?!�?|��?Ĝ:�W�Z�Ϝ����GxG�W��0�-]�\��<�����ʧ�@�����*����h��֛"�)9�}�����a���C�W�qO���$�����g�i,�����G3X��kQ���?�C���T���(B��_~(�C�Onȝ�_L�����!Q���/?|��ϟ�7S{%j=I��%���5�NW\�vZ��!�s��b'���=�O�n<�����fk����VsJ!~t
j�U&�� F������J+�#�J�Nz>@{�m��x���G�}-�����Q������{���� p�(D�������/����/�����h�|P�GQ�9�K�o��?����Z���S��3Q�����x�y7)�{��R�=�߷�  ׅ ^� ��V�W7�T�_��/+fv���^���-�ZO�SY�}��2щ���`d���R���3����*Z�.ʝ]�۬xn}�T�!���T6n�_t�|�r3�s\�`�tL0���X��6�y� r�`��y"�~�7�jU򢱦T���#�5��(��4%��#����O�b+���z1S6�C}*��r�þ�G��|f�x�i�Z�����%�g&�ٳ��c�����92��lu�B�>Z�z-j�����Pl��XX��xN�ʼ�����{G[m�l�O�����/�?F&���'H�B�g�Kwn^)�gjd�޽t�<}��?�T7aԣ����r�ϋ��;j��soZG.�E��t��`k:�Ŀ�r�� %:a��v����l�u�����u����;�����z��������_6���O�_6&�����\/]w�l)������?}J"�y�Sh������Nџ?������������㡚��pt���+�NF%#���K~�xQI�l�'�U�e���FTzg��H���"�(�� 0�#�N`��68!uy��O?���/K��Ou����;l�v�^�_��~����?���ϒ/�W�Y�����ෟ><��LH!}�/J��ۃ�O�y:���r{��޽_z�L�3V��1�A�q�`c,-#(]�R�-=?!�a��������Rl'��=���&���C;�����(}J��;��m�;���5H?�ۻ��b��������	7�������.$y��^h�r��5z�7� {��:P�|=��_N�n[����QXB���k�ܨ�����+��#��b�����%%-��&�>��w�O����=A�o{|�#��sGusi�>L����矔��W5�*��w���ҕ���'���!�    ����r � 