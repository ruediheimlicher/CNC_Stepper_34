FasdUAS 1.101.10   ��   ��    k             l    ����  O      	  k   ~ 
 
     l   ��  ��     activate     �    a c t i v a t e      r        m       �      o      ���� $0 xcodeprojektname XcodeProjektname      r        m    	   �      o      ���� 0 filecontents fileContents      r        4    ��  
�� 
alis   l    !���� ! l    "���� " I   �� # $
�� .earsffdralis        afdr #  f     $ �� %��
�� 
rtyp % m    ��
�� 
ctxt��  ��  ��  ��  ��    o      ���� 0 
homeordner     & ' & l   �� ( )��   ( 0 *display dialog "homeordner: " & homeordner    ) � * * T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e r '  + , + l   ��������  ��  ��   ,  - . - r     / 0 / n     1 2 1 m    ��
�� 
ctnr 2 o    ���� 0 
homeordner   0 o      ���� 0 homeordnerpfad   .  3 4 3 l   �� 5 6��   5 2 ,set main to file "datum.c" of homeordnerpfad    6 � 7 7 X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d 4  8 9 8 r    & : ; : n    $ < = < 1   " $��
�� 
pnam = n    " > ? > 2     "��
�� 
file ? o     ���� 0 homeordnerpfad   ; o      ���� 0 dateienliste Dateienliste 9  @ A @ X   ' O B�� C B Z   9 J D E���� D E   9 > F G F o   9 :���� 0 tempname   G m   : = H H � I I  . x c o d e p r o j E k   A F J J  K L K r   A D M N M o   A B���� 0 tempname   N o      ���� $0 xcodeprojektname XcodeProjektname L  O�� O l  E E�� P Q��   P  display dialog tempname    Q � R R . d i s p l a y   d i a l o g   t e m p n a m e��  ��  ��  �� 0 tempname   C o   * +���� 0 dateienliste Dateienliste A  S T S l  P P��������  ��  ��   T  U V U r   P ] W X W b   P Y Y Z Y l  P U [���� [ c   P U \ ] \ o   P Q���� 0 homeordnerpfad   ] m   Q T��
�� 
TEXT��  ��   Z m   U X ^ ^ � _ _  d a t u m . c X o      ���� 0 filepfad   V  ` a ` l  ^ ^�� b c��   b , &display dialog "filepfad: " & filepfad    c � d d L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d a  e f e l  ^ ^�� g h��   g ! tell application "TextEdit"    h � i i 6 t e l l   a p p l i c a t i o n   " T e x t E d i t " f  j k j I  ^ c������
�� .miscactvnull��� ��� obj ��  ��   k  l m l r   d v n o n l  d r p���� p I  d r�� q r
�� .rdwropenshor       file q 4   d j�� s
�� 
file s o   f i���� 0 filepfad   r �� t��
�� 
perm t m   m n��
�� boovtrue��  ��  ��   o o      ���� 0 refnum RefNum m  u v u Q   w� w x y w k   z� z z  { | { r   z � } ~ } l  z � ����  I  z ��� ���
�� .rdwrread****        **** � o   z }���� 0 refnum RefNum��  ��  ��   ~ o      ���� 0 filecontents fileContents |  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 7 1display dialog "inhalt: " & return & fileContents    � � � � b d i s p l a y   d i a l o g   " i n h a l t :   "   &   r e t u r n   &   f i l e C o n t e n t s �  � � � r   � � � � � n   � � � � � 4   � ��� �
�� 
cpar � m   � �����  � o   � ����� 0 filecontents fileContents � o      ���� 0 datum Datum �  � � � l  � ��� � ���   � &  display dialog "Datum: " & Datum    � � � � @ d i s p l a y   d i a l o g   " D a t u m :   "   &   D a t u m �  � � � r   � � � � � I  � �������
�� .misccurdldt    ��� null��  ��   � o      ���� 	0 heute   �  � � � l  � ��� � ���   � &  display dialog "heute: " & heute    � � � � @ d i s p l a y   d i a l o g   " h e u t e :   "   &   h e u t e �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
year � o   � ����� 	0 heute   � o      ���� 0 jahrtext   �  � � � r   � � � � � n   � � � � � m   � ���
�� 
mnth � o   � ����� 	0 heute   � o      ���� 0 	monattext   �  � � � l  � ��� � ���   � * $display dialog "monat: " & monattext    � � � � H d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t t e x t �  � � � r   � � � � � n   � � � � � 7  � ��� � �
�� 
ctxt � m   � ������� � m   � ������� � l  � � ����� � b   � � � � � m   � � � � � � �  0 � n   � � � � � 1   � ���
�� 
day  � o   � ����� 	0 heute  ��  ��   � o      ���� 0 tag   �  � � � l  � ��� � ���   � " display dialog "tag: " & tag    � � � � 8 d i s p l a y   d i a l o g   " t a g :   "   &   t a g �  � � � r   � � � � � J   � � � �  � � � m   � ���
�� 
jan  �  � � � m   � ���
�� 
feb  �  � � � m   � ���
�� 
mar  �  � � � l 	 � � ����� � m   � ���
�� 
apr ��  ��   �  � � � m   � ���
�� 
may  �  � � � m   � ���
�� 
jun  �  � � � m   � ���
�� 
jul  �  � � � m   � ���
�� 
aug  �  � � � l 	 � � ����� � m   � ���
�� 
sep ��  ��   �  � � � m   � ���
�� 
oct  �  � � � m   � ���
�� 
nov  �  ��� � m   � ���
�� 
dec ��   � o      ���� 0 monatsliste MonatsListe �  � � � Y   �5 ��� � ��� � Z  0 � ����� � =   � � � o  	���� 0 	monattext   � n  	 � � � 4  �� �
�� 
cobj � o  ���� 0 i   � o  	���� 0 monatsliste MonatsListe � k  , � �  � � � r  * � � � n  & � � � 7 &�� � �
�� 
ctxt � m  "������ � m  #%������ � l  ����� � b   � � � m   � � � � �  0 � o  ���� 0 i  ��  ��   � o      ���� 	0 monat   �  �� � l +, � � � �  S  +, � - ' wenn true, wird die Schleife verlassen    � � � � N   w e n n   t r u e ,   w i r d   d i e   S c h l e i f e   v e r l a s s e n�  ��  ��  �� 0 i   � m   � ��~�~  � m   ��}�} ��   �  �  � l 66�|�|   &  display dialog "monat: " & monat    � @ d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t   r  6M l 	6I�{�z l 6I	�y�x	 n 6I

 7 ;I�w
�w 
cha  m  AC�v�v  m  DH�u�u  l 6;�t�s c  6; o  69�r�r 0 jahrtext   m  9:�q
�q 
ctxt�t  �s  �y  �x  �{  �z   o      �p�p 0 jahr    l NN�o�o   ? 9display dialog "jahr: " & jahr & " jahrtext: " & jahrtext    � r d i s p l a y   d i a l o g   " j a h r :   "   &   j a h r   &   "   j a h r t e x t :   "   &   j a h r t e x t  r  N] n  NY m  UY�n
�n 
nmbr n  NU 2 QU�m
�m 
cha  o  NQ�l�l 0 datum Datum o      �k�k 0 l    l ^^�j !�j    1 +set neuesDatum to text -l thru -13 of Datum   ! �"" V s e t   n e u e s D a t u m   t o   t e x t   - l   t h r u   - 1 3   o f   D a t u m #$# l ^q%&'% r  ^q()( n  ^m*+* 7 am�i,-
�i 
ctxt, m  eg�h�h - m  hl�g�g + o  ^a�f�f 0 datum Datum) o      �e�e 0 
neuesdatum 
neuesDatum& $  Anfang bis und mit Leerschlag   ' �.. <   A n f a n g   b i s   u n d   m i t   L e e r s c h l a g$ /0/ l rr�d12�d  1 2 ,display dialog "neuesDatum A: " & neuesDatum   2 �33 X d i s p l a y   d i a l o g   " n e u e s D a t u m   A :   "   &   n e u e s D a t u m0 454 r  r�676 b  r�898 b  r�:;: b  r�<=< b  r�>?> b  r�@A@ b  r}BCB b  ryDED o  ru�c�c 0 
neuesdatum 
neuesDatumE m  uxFF �GG  "C o  y|�b�b 0 tag  A m  }�HH �II  .? o  ���a�a 	0 monat  = m  ��JJ �KK  .; o  ���`�` 0 jahrtext  9 m  ��LL �MM  "7 o      �_�_ 0 
neuesdatum 
neuesDatum5 NON l ���^PQ�^  P 0 *display dialog "neuesDatum: " & neuesDatum   Q �RR T d i s p l a y   d i a l o g   " n e u e s D a t u m :   "   &   n e u e s D a t u mO STS r  ��UVU b  ��WXW b  ��YZY n  ��[\[ 4  ���]]
�] 
cpar] m  ���\�\ \ o  ���[�[ 0 filecontents fileContentsZ o  ���Z
�Z 
ret X o  ���Y�Y 0 
neuesdatum 
neuesDatumV o      �X�X 0 	neuertext 	neuerTextT ^_^ l ���W`a�W  ` 3 -set paragraph 2 of fileContents to neuesDatum   a �bb Z s e t   p a r a g r a p h   2   o f   f i l e C o n t e n t s   t o   n e u e s D a t u m_ cdc l ���Vef�V  e 9 3display dialog "neues Datum: " & return & neuerText   f �gg f d i s p l a y   d i a l o g   " n e u e s   D a t u m :   "   &   r e t u r n   &   n e u e r T e x td hih I ���Ujk
�U .rdwrseofnull���     ****j o  ���T�T 0 refnum RefNumk �Sl�R
�S 
set2l m  ���Q�Q  �R  i mnm I ���Pop
�P .rdwrwritnull���     ****o o  ���O�O 0 	neuertext 	neuerTextp �Nq�M
�N 
refnq o  ���L�L 0 refnum RefNum�M  n r�Kr I ���Js�I
�J .rdwrclosnull���     ****s o  ���H�H 0 refnum RefNum�I  �K   x R      �G�F�E
�G .ascrerr ****      � ****�F  �E   y I ���Dt�C
�D .rdwrclosnull���     ****t o  ���B�B 0 refnum RefNum�C   v uvu l ���A�@�?�A  �@  �?  v wxw l ���>yz�>  y   Neue Version einsetzen   z �{{ .   N e u e   V e r s i o n   e i n s e t z e nx |}| r  ��~~ m  ���� ���   o      �=�= 0 filecontents fileContents} ��� r  ����� 4  ���<�
�< 
alis� l ����;�:� l ����9�8� I ���7��
�7 .earsffdralis        afdr�  f  ��� �6��5
�6 
rtyp� m  ���4
�4 
ctxt�5  �9  �8  �;  �:  � o      �3�3 0 
homeordner  � ��� l ���2���2  � 0 *display dialog "homeordner: " & homeordner   � ��� T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e r� ��� r  ����� n  ����� m  ���1
�1 
ctnr� o  ���0�0 0 
homeordner  � o      �/�/ 0 homeordnerpfad  � ��� r  ����� n  ����� 1  ���.
�. 
pnam� o  ���-�- 0 homeordnerpfad  � o      �,�, 0 projektname Projektname� ��� l ���+���+  � 2 ,display dialog "Projektname: " & Projektname   � ��� X d i s p l a y   d i a l o g   " P r o j e k t n a m e :   "   &   P r o j e k t n a m e� ��� r  ���� n ���� 1  ��*
�* 
txdl� 1  ���)
�) 
ascr� o      �(�( 0 olddels oldDels� ��� r  ��� m  
�� ���  _� n     ��� 1  �'
�' 
txdl� 1  
�&
�& 
ascr� ��� l �%�$�#�%  �$  �#  � ��� r  ��� n  ��� 2 �"
�" 
citm� o  �!�! 0 projektname Projektname� o      � �  0 zeilenliste Zeilenliste� ��� r  *��� n  &��� m  "&�
� 
nmbr� o  "�� 0 zeilenliste Zeilenliste� o      �� 0 	anzzeilen 	anzZeilen� ��� l ++����  � n hdisplay dialog "Zeilenliste: " & return & (Zeilenliste as list) & return & "Anzahl Zeilen: " & anzZeilen   � ��� � d i s p l a y   d i a l o g   " Z e i l e n l i s t e :   "   &   r e t u r n   &   ( Z e i l e n l i s t e   a s   l i s t )   &   r e t u r n   &   " A n z a h l   Z e i l e n :   "   &   a n z Z e i l e n� ��� l ++����  �  �  � ��� l ++����  � � �display dialog "Zeilenliste: " & return & item 1 of Zeilenliste & return & item 2 of Zeilenliste & return & item 3 of Zeilenliste & return & item 4 of Zeilenliste & return & item 5 of Zeilenliste   � ���� d i s p l a y   d i a l o g   " Z e i l e n l i s t e :   "   &   r e t u r n   &   i t e m   1   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   2   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   3   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   4   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   5   o f   Z e i l e n l i s t e� ��� r  +;��� n  +7��� 4  .7��
� 
cobj� l 16���� \  16��� o  14�� 0 	anzzeilen 	anzZeilen� m  45�� �  �  � o  +.�� 0 zeilenliste Zeilenliste� o      �� 0 version1 Version1� ��� r  <J��� n  <F��� 4  ?F��
� 
cobj� o  BE�� 0 	anzzeilen 	anzZeilen� o  <?�� 0 zeilenliste Zeilenliste� o      �� 0 version2 Version2� ��� r  KV��� o  KN�� 0 olddels oldDels� n     ��� 1  QU�
� 
txdl� 1  NQ�

�
 
ascr� ��� l WW�	���	  �  �  � ��� l WW����  � 2 ,set main to file "datum.c" of homeordnerpfad   � ��� X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d� ��� r  Wd��� b  W`��� l W\���� c  W\��� o  WX�� 0 homeordnerpfad  � m  X[�
� 
TEXT�  �  � m  \_�� ���  v e r s i o n . c� o      �� 0 filepfad  � ��� l ee� ���   � , &display dialog "filepfad: " & filepfad   � ��� L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d� ��� r  e���� b  e���� b  e���� b  e�   b  e� b  e| b  ex b  et	 b  ep

 b  el m  eh �  / m  hk �  / m  lo �  v e r s i o n . c	 o  ps��
�� 
ret  m  tw �   # d e f i n e   V E R S I O N   m  x{ �  " o  |���� 0 version1 Version1 m  �� �  .� o  ������ 0 version2 Version2� m  �� �  "� o      ���� 0 
erstertext 
ersterText�  l ������   9 3display dialog "erster Text: " & return & neuerText    �   f d i s p l a y   d i a l o g   " e r s t e r   T e x t :   "   &   r e t u r n   &   n e u e r T e x t !"! l ����������  ��  ��  " #$# I ��������
�� .miscactvnull��� ��� obj ��  ��  $ %&% r  ��'(' l ��)����) I ����*+
�� .rdwropenshor       file* 4  ����,
�� 
file, o  ������ 0 filepfad  + ��-��
�� 
perm- m  ����
�� boovtrue��  ��  ��  ( o      ���� 0 refnum RefNum& ./. Q  �o0120 k  �L33 454 r  ��676 l ��8����8 I ����9��
�� .rdwrread****        ****9 o  ������ 0 refnum RefNum��  ��  ��  7 o      ���� 0 filecontents fileContents5 :;: I ����<��
�� .sysodlogaskr        TEXT< b  ��=>= b  ��?@? m  ��AA �BB  i n h a l t :  @ o  ����
�� 
ret > o  ������ 0 filecontents fileContents��  ; CDC l ����������  ��  ��  D EFE r  ��GHG n  ��IJI 4  ����K
�� 
cparK m  ������ J o  ������ 0 filecontents fileContentsH o      ���� 0 alteversion  F LML l ����NO��  N . (display dialog "Version: " & alteversion   O �PP P d i s p l a y   d i a l o g   " V e r s i o n :   "   &   a l t e v e r s i o nM QRQ r  ��STS n  ��UVU m  ����
�� 
nmbrV n  ��WXW 2 ����
�� 
cha X o  ������ 0 alteversion  T o      ���� 0 l  R YZY l ��[\][ r  ��^_^ n  ��`a` 7 ����bc
�� 
ctxtb m  ������ c m  ������ a o  ������ 0 alteversion  _ o      ���� 0 neueversion neueVersion\ $  Anfang bis und mit Leerschlag   ] �dd <   A n f a n g   b i s   u n d   m i t   L e e r s c h l a gZ efe l ����������  ��  ��  f ghg r  �iji b  �klk b  �mnm b  �opo b  �
qrq b  �sts b  �uvu b  ��wxw n  ��yzy 4  ����{
�� 
cpar{ m  ������ z o  ������ 0 filecontents fileContentsx o  ����
�� 
ret v o  ����� 0 neueversion neueVersiont m  || �}}  "r o  	���� 0 version1 Version1p m  
~~ �  .n o  ���� 0 version2 Version2l m  �� ���  "j o      ���� 0 	neuertext 	neuerTexth ��� l ������  � 4 .set paragraph 2 of fileContents to neueVersion   � ��� \ s e t   p a r a g r a p h   2   o f   f i l e C o n t e n t s   t o   n e u e V e r s i o n� ��� I *�����
�� .sysodlogaskr        TEXT� b  &��� b  "��� m  �� ���  n e u e   V e r s i o n :  � o  !��
�� 
ret � o  "%���� 0 	neuertext 	neuerText��  � ��� I +6����
�� .rdwrseofnull���     ****� o  +.���� 0 refnum RefNum� �����
�� 
set2� m  12����  ��  � ��� I 7D����
�� .rdwrwritnull���     ****� o  7:���� 0 	neuertext 	neuerText� �����
�� 
refn� o  =@���� 0 refnum RefNum��  � ���� I EL�����
�� .rdwrclosnull���     ****� o  EH���� 0 refnum RefNum��  ��  1 R      ������
�� .ascrerr ****      � ****��  ��  2 k  To�� ��� Q  Tm���� k  W^�� ��� l WW������  � w qset ersterText to "/" & "/" & "version.c" & return & "#define VERSION " & "\"" & Version1 & "." & Version2 & "\""   � ��� � s e t   e r s t e r T e x t   t o   " / "   &   " / "   &   " v e r s i o n . c "   &   r e t u r n   &   " # d e f i n e   V E R S I O N   "   &   " \ " "   &   V e r s i o n 1   &   " . "   &   V e r s i o n 2   &   " \ " "� ��� l WW������  � : 4display dialog "erstes  File: " & return & neuerText   � ��� h d i s p l a y   d i a l o g   " e r s t e s     F i l e :   "   &   r e t u r n   &   n e u e r T e x t� ���� I W^�����
�� .rdwrclosnull���     ****� o  WZ���� 0 refnum RefNum��  ��  � R      ������
�� .ascrerr ****      � ****��  ��  � I fm�����
�� .rdwrclosnull���     ****� o  fi���� 0 refnum RefNum��  � ���� l nn������  �  close access RefNum   � ��� & c l o s e   a c c e s s   R e f N u m��  / ��� l pp��������  ��  ��  � ��� n  pu��� I  qu�������� $0 logaktualisieren LogAktualisieren��  ��  �  f  pq� ��� l vv��������  ��  ��  � ���� I v~�����
�� .aevtodocnull  �    alis� n  vz��� 4  wz���
�� 
file� o  xy���� $0 xcodeprojektname XcodeProjektname� o  vw���� 0 homeordnerpfad  ��  ��   	 m     ���                                                                                  MACS  alis    t  Macintosh HD               ���H+   9%�
Finder.app                                                      9�Y�[��        ����  	                CoreServices    �}�      �[ja     9%� 9%� 9%�  6Macintosh HD:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��  ��    ��� l     ��������  ��  ��  � ���� i     ��� I      �������� $0 logaktualisieren LogAktualisieren��  ��  � O    ���� k   ��� ��� I   	������
�� .miscactvnull��� ��� obj ��  ��  � ��� l  
 
��������  ��  ��  � ��� r   
 ��� m   
 �� ���  � o      ���� 0 filecontents fileContents� ��� r    ��� 4    ���
�� 
alis� l   ������ l   ������ I   ���
� .earsffdralis        afdr�  f    � �~��}
�~ 
rtyp� m    �|
�| 
ctxt�}  ��  ��  ��  ��  � o      �{�{ 0 
homeordner  � ��� l   �z���z  � 0 *display dialog "homeordner: " & homeordner   � ��� T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e r� ��� r     ��� n    ��� m    �y
�y 
ctnr� o    �x�x 0 
homeordner  � o      �w�w 0 homeordnerpfad  � ��� l  ! !�v���v  �  open homeordnerpfad   � ��� & o p e n   h o m e o r d n e r p f a d� ��� l  ! !�u���u  � 8 2display dialog "homeordnerpfad: " & homeordnerpfad   � ��� d d i s p l a y   d i a l o g   " h o m e o r d n e r p f a d :   "   &   h o m e o r d n e r p f a d� ��� l  ! !�t���t  � 2 ,set main to file "datum.c" of homeordnerpfad   � ��� X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d� ��� r   ! (��� b   ! &��� l  ! $��s�r� c   ! $� � o   ! "�q�q 0 homeordnerpfad    m   " #�p
�p 
TEXT�s  �r  � m   $ % �  L o g f i l e . t x t� o      �o�o 0 filepfad  �  l  ) )�n�n   , &display dialog "filepfad: " & filepfad    � L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d 	 l  ) )�m�l�k�m  �l  �k  	 

 I  ) .�j�i�h
�j .miscactvnull��� ��� obj �i  �h    r   / 6 I  / 4�g�f�e
�g .misccurdldt    ��� null�f  �e   o      �d�d 	0 heute    l  7 7�c�c   &  display dialog "heute: " & heute    � @ d i s p l a y   d i a l o g   " h e u t e :   "   &   h e u t e  r   7 < n   7 : 1   8 :�b
�b 
year o   7 8�a�a 	0 heute   o      �`�` 0 jahrtext    r   = B n   = @  m   > @�_
�_ 
mnth  o   = >�^�^ 	0 heute   o      �]�] 0 	monattext   !"! l  C C�\#$�\  # * $display dialog "monat: " & monattext   $ �%% H d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t t e x t" &'& r   C T()( n   C R*+* 7  H R�[,-
�[ 
ctxt, m   L N�Z�Z��- m   O Q�Y�Y��+ l  C H.�X�W. b   C H/0/ m   C D11 �22  00 n   D G343 1   E G�V
�V 
day 4 o   D E�U�U 	0 heute  �X  �W  ) o      �T�T 0 tag  ' 565 l  U U�S78�S  7 " display dialog "tag: " & tag   8 �99 8 d i s p l a y   d i a l o g   " t a g :   "   &   t a g6 :;: r   U <=< J   U }>> ?@? m   U X�R
�R 
jan @ ABA m   X [�Q
�Q 
feb B CDC m   [ ^�P
�P 
mar D EFE l 	 ^ aG�O�NG m   ^ a�M
�M 
apr �O  �N  F HIH m   a d�L
�L 
may I JKJ m   d g�K
�K 
jun K LML m   g j�J
�J 
jul M NON m   j m�I
�I 
aug O PQP l 	 m pR�H�GR m   m p�F
�F 
sep �H  �G  Q STS m   p s�E
�E 
oct T UVU m   s v�D
�D 
nov V W�CW m   v y�B
�B 
dec �C  = o      �A�A 0 monatsliste MonatsListe; XYX Y   � �Z�@[\�?Z Z   � �]^�>�=] =   � �_`_ o   � ��<�< 0 	monattext  ` n   � �aba 4   � ��;c
�; 
cobjc o   � ��:�: 0 i  b o   � ��9�9 0 monatsliste MonatsListe^ k   � �dd efe r   � �ghg n   � �iji 7  � ��8kl
�8 
ctxtk m   � ��7�7��l m   � ��6�6��j l  � �m�5�4m b   � �non m   � �pp �qq  0o o   � ��3�3 0 i  �5  �4  h o      �2�2 	0 monat  f r�1r l  � �stus  S   � �t - ' wenn true, wird die Schleife verlassen   u �vv N   w e n n   t r u e ,   w i r d   d i e   S c h l e i f e   v e r l a s s e n�1  �>  �=  �@ 0 i  [ m   � ��0�0 \ m   � ��/�/ �?  Y wxw l  � ��.yz�.  y &  display dialog "monat: " & monat   z �{{ @ d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a tx |}| r   � �~~ l 	 � ���-�,� l  � ���+�*� n  � ���� 7  � ��)��
�) 
cha � m   � ��(�( � m   � ��'�' � l  � ���&�%� c   � ���� o   � ��$�$ 0 jahrtext  � m   � ��#
�# 
ctxt�&  �%  �+  �*  �-  �,   o      �"�" 0 jahr  } ��� l  � ��!���!  � ? 9display dialog "jahr: " & jahr & " jahrtext: " & jahrtext   � ��� r d i s p l a y   d i a l o g   " j a h r :   "   &   j a h r   &   "   j a h r t e x t :   "   &   j a h r t e x t� ��� l  � �� ���   � , &set l to number of characters of Datum   � ��� L s e t   l   t o   n u m b e r   o f   c h a r a c t e r s   o f   D a t u m� ��� l  � �����  � 1 +set neuesDatum to text -l thru -13 of Datum   � ��� V s e t   n e u e s D a t u m   t o   t e x t   - l   t h r u   - 1 3   o f   D a t u m� ��� l  � �����  � P Jset neuesDatum to text 1 thru 14 of Datum -- Anfang bis und mit Leerschlag   � ��� � s e t   n e u e s D a t u m   t o   t e x t   1   t h r u   1 4   o f   D a t u m   - -   A n f a n g   b i s   u n d   m i t   L e e r s c h l a g� ��� r   � ���� b   � ���� b   � ���� b   � ���� b   � ���� o   � ��� 0 tag  � m   � ��� ���  .� o   � ��� 	0 monat  � m   � ��� ���  .� o   � ��� 0 jahrtext  � o      �� 0 
neuesdatum 
neuesDatum� ��� l  � �����  � 0 *display dialog "neuesDatum: " & neuesDatum   � ��� T d i s p l a y   d i a l o g   " n e u e s D a t u m :   "   &   n e u e s D a t u m� ��� l  � �����  �  �  � ��� l  � �����  �  �  � ��� r   � ���� l  � ����� I  � ����
� .rdwropenshor       file� 4   � ���
� 
file� o   � ��� 0 filepfad  � ���
� 
perm� m   � ��
� boovtrue�  �  �  � o      �
�
 0 refnum RefNum� ��� Q   �T���� k   �G�� ��� r   � ���� l  � ���	�� I  � ����
� .rdwrread****        ****� o   � ��� 0 refnum RefNum�  �	  �  � o      �� 0 filecontents fileContents� ��� r   ���� n   � ���� 4  � ���
� 
cwor� m   � ������ l  � ���� � n   � ���� 4   � ����
�� 
cpar� m   � ����� � o   � ����� 0 filecontents fileContents�  �   � o      ���� 0 	lastdatum 	lastDatum� ��� l ������  � 7 1display dialog "lastDatum: " & return & lastDatum   � ��� b d i s p l a y   d i a l o g   " l a s t D a t u m :   "   &   r e t u r n   &   l a s t D a t u m� ��� l ������  � . (set Datum to paragraph 2 of fileContents   � ��� P s e t   D a t u m   t o   p a r a g r a p h   2   o f   f i l e C o n t e n t s� ��� l ������  � &  display dialog "Datum: " & Datum   � ��� @ d i s p l a y   d i a l o g   " D a t u m :   "   &   D a t u m� ��� Z  A������ = ��� o  ���� 0 
neuesdatum 
neuesDatum� o  ���� 0 	lastdatum 	lastDatum� l ������  � % display dialog "gleiches Datum"   � ��� > d i s p l a y   d i a l o g   " g l e i c h e s   D a t u m "��  � k  A�� ��� l ��������  ��  ��  � ��� r  -��� b  +��� b  '��� b  %��� b  !��� b  ��� b     b   b   m   � T * * * * * * * * * * * * * * * * * * * * * *                                         o  ���� 0 
neuesdatum 
neuesDatum o  ��
�� 
ret  l 	���� o  ��
�� 
ret ��  ��  � o  ��
�� 
ret � l 	 	����	 m   

 � , * * * * * * * * * * * * * * * * * * * * * *��  ��  � o  !$��
�� 
ret � o  %&���� 0 filecontents fileContents� o  '*��
�� 
ret � o      ���� 0 	neuertext 	neuerText�  I .7��
�� .rdwrseofnull���     **** o  ./���� 0 refnum RefNum ����
�� 
set2 m  23����  ��   �� I 8A��
�� .rdwrwritnull���     **** o  89���� 0 	neuertext 	neuerText ����
�� 
refn o  <=���� 0 refnum RefNum��  ��  � �� I BG����
�� .rdwrclosnull���     **** o  BC���� 0 refnum RefNum��  ��  � R      ������
�� .ascrerr ****      � ****��  ��  � k  OT  l OO��������  ��  ��   �� I OT����
�� .rdwrclosnull���     **** o  OP���� 0 refnum RefNum��  ��  �  l UU����    start    �   
 s t a r t !"! r  U^#$# J  UZ%% &��& m  UX'' �((  x c o d e p r o j��  $ o      ���� 0 filetype  " )*) l __��+,��  + ? 9set projektpfad to (path to alias (homeordner)) as string   , �-- r s e t   p r o j e k t p f a d   t o   ( p a t h   t o   a l i a s   ( h o m e o r d n e r ) )   a s   s t r i n g* ./. l __��01��  0 0 *display dialog "projektpfad" & projektpfad   1 �22 T d i s p l a y   d i a l o g   " p r o j e k t p f a d "   &   p r o j e k t p f a d/ 343 l __��56��  5 8 2display dialog "homeordnerpfad: " & homeordnerpfad   6 �77 d d i s p l a y   d i a l o g   " h o m e o r d n e r p f a d :   "   &   h o m e o r d n e r p f a d4 898 l __��:;��  : > 8get name of folders of folder (homeordnerpfad as string)   ; �<< p g e t   n a m e   o f   f o l d e r s   o f   f o l d e r   ( h o m e o r d n e r p f a d   a s   s t r i n g )9 =>= l _s?@A? r  _sBCB n  _oDED 1  ko��
�� 
pnamE n  _kFGF 2 gk��
�� 
fileG 4  _g��H
�� 
cfolH l cfI����I c  cfJKJ o  cd���� 0 homeordnerpfad  K m  de��
�� 
TEXT��  ��  C o      ���� 
0 inhalt  @  without invisibles   A �LL $ w i t h o u t   i n v i s i b l e s> MNM l tt��OP��  O # display dialog inhalt as text   P �QQ : d i s p l a y   d i a l o g   i n h a l t   a s   t e x tN RSR l tt��TU��  T 7 1repeat with i from 1 to number of items of inhalt   U �VV b r e p e a t   w i t h   i   f r o m   1   t o   n u m b e r   o f   i t e m s   o f   i n h a l tS W��W X  t�X��YX k  ��ZZ [\[ l ����]^��  ] &  display dialog (dasFile) as text   ^ �__ @ d i s p l a y   d i a l o g   ( d a s F i l e )   a s   t e x t\ `��` Z  ��ab����a E  ��cdc l ��e����e l ��f����f o  ������ 0 dasfile dasFile��  ��  ��  ��  d m  ��gg �hh  x c o d e p r o jb k  ��ii jkj r  ��lml b  ��non l ��p����p c  ��qrq o  ������ 0 homeordnerpfad  r m  ����
�� 
ctxt��  ��  o l ��s����s c  ��tut o  ������ 0 dasfile dasFileu m  ����
�� 
ctxt��  ��  m o      ���� 0 filepfad  k vwv l ����xy��  x &  display dialog (dasFile) as text   y �zz @ d i s p l a y   d i a l o g   ( d a s F i l e )   a s   t e x tw {��{ I ����|��
�� .aevtodocnull  �    alis| 4  ����}
�� 
file} o  ������ 0 filepfad  ��  ��  ��  ��  ��  �� 0 dasfile dasFileY o  wz���� 
0 inhalt  ��  � m     ~~�                                                                                  MACS  alis    t  Macintosh HD               ���H+   9%�
Finder.app                                                      9�Y�[��        ����  	                CoreServices    �}�      �[ja     9%� 9%� 9%�  6Macintosh HD:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��       "��������������������������������������������    ��������������������������������������������������~�}�|�{�z�y�x�� $0 logaktualisieren LogAktualisieren
�� .aevtoappnull  �   � ****�� $0 xcodeprojektname XcodeProjektname�� 0 filecontents fileContents�� 0 
homeordner  �� 0 homeordnerpfad  �� 0 dateienliste Dateienliste�� 0 filepfad  �� 0 refnum RefNum�� 0 datum Datum�� 	0 heute  �� 0 jahrtext  �� 0 	monattext  �� 0 tag  �� 0 monatsliste MonatsListe�� 	0 monat  �� 0 jahr  �� 0 l  �� 0 
neuesdatum 
neuesDatum�� 0 	neuertext 	neuerText�� 0 projektname Projektname�� 0 olddels oldDels�� 0 zeilenliste Zeilenliste�� 0 	anzzeilen 	anzZeilen� 0 version1 Version1�~ 0 version2 Version2�} 0 
erstertext 
ersterText�| 0 alteversion  �{ 0 neueversion neueVersion�z  �y  �x  � �w��v�u���t�w $0 logaktualisieren LogAktualisieren�v  �u  � �s�r�q�p�o�n�m�l�k�j�i�h�g�f�e�d�c�b�a�s 0 filecontents fileContents�r 0 
homeordner  �q 0 homeordnerpfad  �p 0 filepfad  �o 	0 heute  �n 0 jahrtext  �m 0 	monattext  �l 0 tag  �k 0 monatsliste MonatsListe�j 0 i  �i 	0 monat  �h 0 jahr  �g 0 
neuesdatum 
neuesDatum�f 0 refnum RefNum�e 0 	lastdatum 	lastDatum�d 0 	neuertext 	neuerText�c 0 filetype  �b 
0 inhalt  �a 0 dasfile dasFile� :~�`��_�^�]�\�[�Z�Y�X�W1�V�U�T�S�R�Q�P�O�N�M�L�K�J�I�H�Gp�F�E���D�C�B�A�@�?�>
�=�<�;�:�9�8�7'�6�5�4�3g�2
�` .miscactvnull��� ��� obj 
�_ 
alis
�^ 
rtyp
�] 
ctxt
�\ .earsffdralis        afdr
�[ 
ctnr
�Z 
TEXT
�Y .misccurdldt    ��� null
�X 
year
�W 
mnth
�V 
day �U��
�T 
jan 
�S 
feb 
�R 
mar 
�Q 
apr 
�P 
may 
�O 
jun 
�N 
jul 
�M 
aug 
�L 
sep 
�K 
oct 
�J 
nov 
�I 
dec �H 
�G 
cobj
�F 
cha �E 
�D 
file
�C 
perm
�B .rdwropenshor       file
�A .rdwrread****        ****
�@ 
cpar
�? 
cwor
�> 
ret 
�= 
set2
�< .rdwrseofnull���     ****
�; 
refn
�: .rdwrwritnull���     ****
�9 .rdwrclosnull���     ****�8  �7  
�6 
cfol
�5 
pnam
�4 
kocl
�3 .corecnte****       ****
�2 .aevtodocnull  �    alis�t���*j O�E�O*�)��l /E�O��,E�O��&�%E�O*j O*j 
E�O��,E�O��,E�O���,%[�\[Z�\Zi2E�Oa a a a a a a a a a a a a vE�O 2ka kh 	��a �/  a �%[�\[Z�\Zi2E�OY h[OY��O��&[a \[Zm\Za  2E�O�a !%�%a "%�%E�O*a #�/a $el %E�O `�j &E�O�a 'k/a (i/E�O��  hY 7a )�%_ *%_ *%_ *%a +%_ *%�%_ *%E�O�a ,jl -O�a .�l /O�j 0W X 1 2�j 0Oa 3kvE^ O*a 4��&/a #-a 5,E^ O >] [a 6a l 7kh ] a 8 ��&] �&%E�O*a #�/j 9Y h[OY��U� �1��0�/���.
�1 .aevtoappnull  �   � ****� k    ��  �-�-  �0  �/  � �,�+�, 0 tempname  �+ 0 i  � j� �* �)�(�'�&�%�$�#�"�!� ���� H� ^�������������� ����
�	��������� �������� �����������������FHJL�����������������������������������������A��������|~�������* $0 xcodeprojektname XcodeProjektname�) 0 filecontents fileContents
�( 
alis
�' 
rtyp
�& 
ctxt
�% .earsffdralis        afdr�$ 0 
homeordner  
�# 
ctnr�" 0 homeordnerpfad  
�! 
file
�  
pnam� 0 dateienliste Dateienliste
� 
kocl
� 
cobj
� .corecnte****       ****
� 
TEXT� 0 filepfad  
� .miscactvnull��� ��� obj 
� 
perm
� .rdwropenshor       file� 0 refnum RefNum
� .rdwrread****        ****
� 
cpar� 0 datum Datum
� .misccurdldt    ��� null� 	0 heute  
� 
year� 0 jahrtext  
� 
mnth� 0 	monattext  
� 
day ����
 0 tag  
�	 
jan 
� 
feb 
� 
mar 
� 
apr 
� 
may 
� 
jun 
� 
jul 
� 
aug 
� 
sep 
�  
oct 
�� 
nov 
�� 
dec �� �� 0 monatsliste MonatsListe�� 	0 monat  
�� 
cha �� �� 0 jahr  
�� 
nmbr�� 0 l  �� �� 0 
neuesdatum 
neuesDatum
�� 
ret �� 0 	neuertext 	neuerText
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****��  ��  �� 0 projektname Projektname
�� 
ascr
�� 
txdl�� 0 olddels oldDels
�� 
citm�� 0 zeilenliste Zeilenliste�� 0 	anzzeilen 	anzZeilen�� 0 version1 Version1�� 0 version2 Version2�� 0 
erstertext 
ersterText
�� .sysodlogaskr        TEXT�� 0 alteversion  �� �� 0 neueversion neueVersion�� $0 logaktualisieren LogAktualisieren
�� .aevtodocnull  �    alis�.��|�E�O�E�O*�)��l /E�O��,E�O��-�,E�O '�[�a l kh  �a  
�E�OPY h[OY��O�a &a %E` O*j O*�_ /a el E` OU_ j E�O�a l/E` O*j E` O_ a ,E`  O_ a !,E` "Oa #_ a $,%[�\[Za %\Zi2E` &Oa 'a (a )a *a +a ,a -a .a /a 0a 1a 2a 3vE` 4O :ka 3kh _ "_ 4a �/  a 5�%[�\[Za %\Zi2E` 6OY h[OY��O_  �&[a 7\[Zm\Za 82E` 9O_ a 7-a :,E` ;O_ [�\[Zk\Za <2E` =O_ =a >%_ &%a ?%_ 6%a @%_  %a A%E` =O�a k/_ B%_ =%E` CO_ a Djl EO_ Ca F_ l GO_ j HW X I J_ j HOa KE�O*�)��l /E�O��,E�O��,E` LO_ Ma N,E` OOa P_ Ma N,FO_ La Q-E` RO_ Ra :,E` SO_ Ra _ Sk/E` TO_ Ra _ S/E` UO_ O_ Ma N,FO�a &a V%E` Oa Wa X%a Y%_ B%a Z%a [%_ T%a \%_ U%a ]%E` ^O*j O*�_ /a el E` O �_ j E�Oa __ B%�%j `O�a l/E` aO_ aa 7-a :,E` ;O_ a[�\[Zk\Za b2E` cO�a k/_ B%_ c%a d%_ T%a e%_ U%a f%E` COa g_ B%_ C%j `O_ a Djl EO_ Ca F_ l GO_ j HW "X I J _ j HW X I J_ j HOPO)j+ hO���/j iU� �� ������ ����� <� < ������������������������������������������������������������� ��� @   D a t u m _ V e r s i o n _ a k t u a l i s i e r e n . a p p� ��� B   D a t u m _ V e r s i o n _ a k t u a l i s i e r e n . s c p t� ���  H a l t . j p g� ���  H a l t _ a l t . j p g� ���  H o m e b u s . p a g e s� ���  I O W a r r i o r L i b . c� ���  I O W a r r i o r L i b . h� ��� 6 I O W a r r i o r W i n d o w C o n t r o l l e r . h� ��� 6 I O W a r r i o r W i n d o w C o n t r o l l e r . m� ���  L o g f i l e . t x t� ��� 4 M a c r o N a m e P a n e l C o n t r o l l e r . h� ��� 4 M a c r o N a m e P a n e l C o n t r o l l e r . m� ���  P f e i l d o w n . i c o� ���  P u n k t . j p g� ���  R E A D M E� ��� 
 S P I . c� ���  U S B . i c n s� ���  U S B . j p g� ��� * U S B _ S t e p p e r . x c o d e p r o j� ��� , U S B _ S t e p p e r _ P r e f i x . p c h� ���  d a t u m . c� ��� 
 h i d . c� ��� 
 h i d . h� ���  h o m e . j p g� ���  i n f o . p l i s t� ���  m a i n . m� ���  p f e i l _ d o w n . j p g� ��� & p f e i l _ d o w n _ m i n i . j p g� ���  p f e i l _ l i n k s . j p g� ��� ( p f e i l _ l i n k s _ m i n i . j p g� ���   p f e i l _ r e c h t s . j p g� ��� * p f e i l _ r e c h t s _ m i n i . j p g� ���  p f e i l _ u p . j p g� ��� " p f e i l _ u p _ m i n i . j p g� ���  p u n k t _ r o t . j p g� ���  p u n k t _ w e i s s . j p g� �    r A D W a n d l e r . h� �  r A D W a n d l e r . m� �  r A V R . h� �  r A V R . m� �   r A V R C o n t r o l l e r . m� �  r C N C . h� �  r C N C . m� �  r D u m p _ D S . h� �  r D u m p _ D S . m� �		   r E i n s t e l l u n g e n . h� �

   r E i n s t e l l u n g e n . m� � 4 r E i n s t e l l u n g e n C o n t r o l l e r . m� �  r E l e m e n t . h� �  r E l e m e n t . m� �  r I n p u t . m� �  r P r o f i l _ D S . h� �  r P r o f i l _ D S . m� �  r T a s t e . h� �  r T a s t e . m� �  r U t i l s . h� �  r U t i l s . m� �  s t o p . j p g� �  v e r s i o n . c� �  v e r s i o n . p l i s t
�� 
cobj�� � � V / / v e r s i o n . c  # d e f i n e   V E R S I O N   " U S B . S t e p p e r 3 4 "�  �� �� ��  ��!  "��#" $��%$ &��'& (��)( *��+* ���
�� 
sdsk
�� 
cfol+ �,, 
 U s e r s
�� 
cfol) �--  r u e d i h e i m l i c h e r
�� 
cfol' �..  D o c u m e n t s
�� 
cfol% �//  E l e k t r o n i k
�� 
cfol# �00  C N C - P r o j e k t
�� 
cfol! �11  I O W _ S t e p p e r
�� 
cfol �22  C N C _ S t e p p e r
�� 
cfol �33  U S B _ S t e p p e r 3 4
�� 
docf �44 B   D a t u m _ V e r s i o n _ a k t u a l i s i e r e n . s c p t� 55 6��76 8��98 :��;: <��=< >��?> @��A@ B��CB D��ED ���
�� 
sdsk
�� 
cfolE �FF 
 U s e r s
�� 
cfolC �GG  r u e d i h e i m l i c h e r
�� 
cfolA �HH  D o c u m e n t s
�� 
cfol? �II  E l e k t r o n i k
�� 
cfol= �JJ  C N C - P r o j e k t
�� 
cfol; �KK  I O W _ S t e p p e r
�� 
cfol9 �LL  C N C _ S t e p p e r
�� 
cfol7 �MM  U S B _ S t e p p e r 3 4� �NN � M a c i n t o s h   H D : U s e r s : r u e d i h e i m l i c h e r : D o c u m e n t s : E l e k t r o n i k : C N C - P r o j e k t : I O W _ S t e p p e r : C N C _ S t e p p e r : U S B _ S t e p p e r 3 4 : v e r s i o n . c�� .� �OO 4 # d e f i n e   D A T U M   " 2 2 . 0 6 . 2 0 1 2 "� ldt     �
Ya���
�� 
jun � �PP  2 2� ��Q�� Q  ������������������������
�� 
jan 
�� 
feb 
�� 
mar 
�� 
apr 
�� 
may 
�� 
jun 
�� 
jul 
�� 
aug 
�� 
sep 
�� 
oct 
�� 
nov 
�� 
dec � �RR  0 6� ��S�� S  TU����������������������������T �VV  1U �WW  2��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  �� � �XX 4 # d e f i n e   D A T U M   " 2 2 . 0 6 . 2 0 1 2 "� �YY V / / v e r s i o n . c  # d e f i n e   V E R S I O N   " U S B . S t e p p e r 3 4 "� �ZZ  U S B _ S t e p p e r 3 4� ��[�� [  \\ �]]  � ��^�� ^  ������������������������������� �__  U S B� �``  S t e p p e r 3 4��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  �� � �aa V / / v e r s i o n . c  # d e f i n e   V E R S I O N   " U S B . S t e p p e r 3 4 "� �bb > # d e f i n e   V E R S I O N   " U S B . S t e p p e r 3 4 "� �cc   # d e f i n e   V E R S I O N  ��  ��  ��   ascr  ��ޭ