FasdUAS 1.101.10   ��   ��    k             l   T ����  O    T  	  k   S 
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
�D .rdwrclosnull���     ****t o  ���B�B 0 refnum RefNum�C   v uvu l ���A�@�?�A  �@  �?  v wxw l ���>yz�>  y   Neue Version einsetzen   z �{{ .   N e u e   V e r s i o n   e i n s e t z e nx |}| r  ��~~ m  ���� ���   o      �=�= 0 filecontents fileContents} ��� l ���<���<  � 4 .set homeordner to alias ((path to me as text))   � ��� \ s e t   h o m e o r d n e r   t o   a l i a s   ( ( p a t h   t o   m e   a s   t e x t ) )� ��� l ���;���;  � 4 .set homeordner to alias ((path to me as text))   � ��� \ s e t   h o m e o r d n e r   t o   a l i a s   ( ( p a t h   t o   m e   a s   t e x t ) )� ��� l ���:���:  � 2 ,display dialog "homeordner 2: " & homeordner   � ��� X d i s p l a y   d i a l o g   " h o m e o r d n e r   2 :   "   &   h o m e o r d n e r� ��� r  ����� n  ����� m  ���9
�9 
ctnr� o  ���8�8 0 
homeordner  � o      �7�7 0 homeordnerpfad  � ��� r  ����� n  ����� 1  ���6
�6 
pnam� o  ���5�5 0 homeordnerpfad  � o      �4�4 0 projektname Projektname� ��� l ���3���3  � 2 ,display dialog "Projektname: " & Projektname   � ��� X d i s p l a y   d i a l o g   " P r o j e k t n a m e :   "   &   P r o j e k t n a m e� ��� r  ����� n ����� 1  ���2
�2 
txdl� 1  ���1
�1 
ascr� o      �0�0 0 olddels oldDels� ��� r  ���� m  ���� ���  _� n     ��� 1   �/
�/ 
txdl� 1  � �.
�. 
ascr� ��� l �-�,�+�-  �,  �+  � ��� r  ��� n  ��� 2 	�*
�* 
citm� o  	�)�) 0 projektname Projektname� o      �(�( 0 zeilenliste Zeilenliste� ��� r  ��� n  ��� m  �'
�' 
nmbr� o  �&�& 0 zeilenliste Zeilenliste� o      �%�% 0 	anzzeilen 	anzZeilen� ��� l �$���$  � n hdisplay dialog "Zeilenliste: " & return & (Zeilenliste as list) & return & "Anzahl Zeilen: " & anzZeilen   � ��� � d i s p l a y   d i a l o g   " Z e i l e n l i s t e :   "   &   r e t u r n   &   ( Z e i l e n l i s t e   a s   l i s t )   &   r e t u r n   &   " A n z a h l   Z e i l e n :   "   &   a n z Z e i l e n� ��� l �#�"�!�#  �"  �!  � ��� l � ���   � � �display dialog "Zeilenliste: " & return & item 1 of Zeilenliste & return & item 2 of Zeilenliste & return & item 3 of Zeilenliste & return --& item 4 of Zeilenliste & return & item 5 of Zeilenliste   � ���� d i s p l a y   d i a l o g   " Z e i l e n l i s t e :   "   &   r e t u r n   &   i t e m   1   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   2   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   3   o f   Z e i l e n l i s t e   &   r e t u r n   - - &   i t e m   4   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   5   o f   Z e i l e n l i s t e� ��� r  .��� n  *��� 4  !*��
� 
cobj� l $)���� \  $)��� o  $'�� 0 	anzzeilen 	anzZeilen� m  '(�� �  �  � o  !�� 0 zeilenliste Zeilenliste� o      �� 0 version1 Version1� ��� r  /=��� n  /9��� 4  29��
� 
cobj� o  58�� 0 	anzzeilen 	anzZeilen� o  /2�� 0 zeilenliste Zeilenliste� o      �� 0 version2 Version2� ��� l >>����  �  �  � ��� r  >I��� o  >A�� 0 olddels oldDels� n     ��� 1  DH�
� 
txdl� 1  AD�
� 
ascr� ��� l JJ����  �  �  � ��� l JJ����  � 2 ,set main to file "datum.c" of homeordnerpfad   � ��� X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d� ��� r  JW��� b  JS��� l JO��
�	� c  JO��� o  JK�� 0 homeordnerpfad  � m  KN�
� 
TEXT�
  �	  � m  OR�� ���  v e r s i o n . c� o      �� 0 filepfad  � ��� l XX����  � , &display dialog "filepfad: " & filepfad   � ��� L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d� ��� r  X���� b  X��� b  X{   b  Xw b  Xs b  Xo b  Xk	 b  Xg

 b  Xc b  X_ m  X[ �  / m  [^ �  / m  _b �  v e r s i o n . c o  cf�
� 
ret 	 m  gj �   # d e f i n e   V E R S I O N   m  kn �  " o  or�� 0 version1 Version1 m  sv �  . o  wz�� 0 version2 Version2� m  {~ �  "� o      �� 0 
erstertext 
ersterText�  l ���  !�     : 4display dialog "erster Text: " & return & ersterText   ! �"" h d i s p l a y   d i a l o g   " e r s t e r   T e x t :   "   &   r e t u r n   &   e r s t e r T e x t #$# l ����������  ��  ��  $ %&% l ����������  ��  ��  & '(' I ��������
�� .miscactvnull��� ��� obj ��  ��  ( )*) Q  �C+,-+ k  �.. /0/ l ����������  ��  ��  0 121 r  ��343 l ��5����5 I ����67
�� .rdwropenshor       file6 4  ����8
�� 
file8 o  ������ 0 filepfad  7 ��9��
�� 
perm9 m  ����
�� boovtrue��  ��  ��  4 o      ���� 0 refnum RefNum2 :;: r  ��<=< l ��>����> I ����?��
�� .rdwrread****        ****? o  ������ 0 refnum RefNum��  ��  ��  = o      ���� 0 filecontents fileContents; @A@ l ����BC��  B 7 1display dialog "inhalt: " & return & fileContents   C �DD b d i s p l a y   d i a l o g   " i n h a l t :   "   &   r e t u r n   &   f i l e C o n t e n t sA EFE l ����������  ��  ��  F GHG r  ��IJI n  ��KLK 4  ����M
�� 
cparM m  ������ L o  ������ 0 filecontents fileContentsJ o      ���� 0 alteversion  H NON l ����PQ��  P 3 -display dialog "alte Version: " & alteversion   Q �RR Z d i s p l a y   d i a l o g   " a l t e   V e r s i o n :   "   &   a l t e v e r s i o nO STS r  ��UVU n  ��WXW m  ����
�� 
nmbrX n  ��YZY 2 ����
�� 
cha Z o  ������ 0 alteversion  V o      ���� 0 l  T [\[ l ��]^_] r  ��`a` n  ��bcb 7 ����de
�� 
ctxtd m  ������ e m  ������ c o  ������ 0 alteversion  a o      ���� 0 neueversion neueVersion^ $  Anfang bis und mit Leerschlag   _ �ff <   A n f a n g   b i s   u n d   m i t   L e e r s c h l a g\ ghg l ��ijki r  ��lml n  ��non 7 ����pq
�� 
ctxtp l ��r����r \  ��sts o  ������ 0 l  t m  ������ ��  ��  q l ��u����u \  ��vwv o  ������ 0 l  w m  ������ ��  ��  o o  ������ 0 alteversion  m o      ���� &0 alteversionnummer alteVersionnummerj      k �xx   h yzy l ��{|}{ I ����~��
�� .sysodlogaskr        TEXT~ b  ��� m  ���� ��� & a l t e V e r s i o n n u m m e r :  � o  ������ &0 alteversionnummer alteVersionnummer��  | 9 3& " als integer: " & (alteVersionnummer as integer)   } ��� f &   "   a l s   i n t e g e r :   "   &   ( a l t e V e r s i o n n u m m e r   a s   i n t e g e r )z ��� l ����������  ��  ��  � ��� r  �*��� I �&����
�� .sysodlogaskr        TEXT� m  ��� ���  V e r s i o n u m m e r :� ����
�� 
dtxt� l 	������ o  ���� &0 alteversionnummer alteVersionnummer��  ��  � ����
�� 
btns� l 	������ J  �� ��� m  �� ���  O K� ��� m  �� ���  I n c r e m e n t� ���� m  �� ���  n e u   s e t z e n��  ��  ��  � ����
�� 
dflt� l 
������ m  ���� ��  ��  � �����
�� 
disp� m   ��
�� stic   ��  � o      ���� 0 antwort  � ��� l ++��������  ��  ��  � ��� l ++������  � # set DialogResultat to result    � ��� : s e t   D i a l o g R e s u l t a t   t o   r e s u l t  � ��� l ++������  � � �display dialog "button returned: " & button returned of result --& "text: " & text returned of antwort & "resultat: " & DialogResultat --& "antwort: " & antwort   � ���@ d i s p l a y   d i a l o g   " b u t t o n   r e t u r n e d :   "   &   b u t t o n   r e t u r n e d   o f   r e s u l t   - - &   " t e x t :   "   &   t e x t   r e t u r n e d   o f   a n t w o r t   &   " r e s u l t a t :   "   &   D i a l o g R e s u l t a t   - - &   " a n t w o r t :   "   &   a n t w o r t� ��� l ++��������  ��  ��  � ��� l ++������  � . (if button returned of result = "OK" then   � ��� P i f   b u t t o n   r e t u r n e d   o f   r e s u l t   =   " O K "   t h e n� ��� r  +2��� o  +.���� &0 alteversionnummer alteVersionnummer� o      ���� 0 versionnummer versionNummer� ��� l 33������  �  end if   � ���  e n d   i f� ��� Z  3������� = 3>��� n  3:��� 1  6:��
�� 
bhit� o  36���� 0 antwort  � m  :=�� ���  I n c r e m e n t� k  A��� ��� l AA������  �  display dialog "erh�hen"   � ��� 0 d i s p l a y   d i a l o g   " e r h � h e n "� ��� r  AN��� [  AJ��� l AH������ c  AH��� o  AD���� &0 alteversionnummer alteVersionnummer� m  DG��
�� 
long��  ��  � m  HI���� � o      ���� &0 neueversionnummer neueVersionnummer� ��� Z  O������� l OV������ A  OV��� o  OR���� &0 neueversionnummer neueVersionnummer� m  RU���� 
��  ��  � r  Yf��� b  Yb��� m  Y\�� ���  0 0� l \a������ c  \a��� o  \_���� &0 neueversionnummer neueVersionnummer� m  _`��
�� 
ctxt��  ��  � o      ���� &0 neueversionnummer neueVersionnummer� ��� l ip������ A  ip��� o  il���� &0 neueversionnummer neueVersionnummer� m  lo���� d��  ��  � ��� r  s~��� b  sz��� m  sv�� ���  0� o  vy���� &0 neueversionnummer neueVersionnummer� o      ���� &0 neueversionnummer neueVersionnummer� ��� l �������� ?  ����� o  ������ &0 neueversionnummer neueVersionnummer� m  ������ ���  ��  � ���� r  ����� m  ��   �  0 0 1� o      ���� &0 neueversionnummer neueVersionnummer��  ��  �  r  �� o  ������ &0 neueversionnummer neueVersionnummer o      ���� 0 versionnummer versionNummer �� l ������   = 7display dialog "neue Versionummer:" & neueVersionnummer    �		 n d i s p l a y   d i a l o g   " n e u e   V e r s i o n u m m e r : "   &   n e u e V e r s i o n n u m m e r��  � 

 = �� n  �� 1  ����
�� 
bhit o  ���� 0 antwort   m  �� �  n e u   s e t z e n �~ k  ��  l ���}�}   G Adisplay dialog "neu setzen: 3" & (text returned of antwort) & "*"    � � d i s p l a y   d i a l o g   " n e u   s e t z e n :   3 "   &   ( t e x t   r e t u r n e d   o f   a n t w o r t )   &   " * "  r  �� l ���|�{ n  �� 1  ���z
�z 
ttxt o  ���y�y 0 antwort  �|  �{   o      �x�x 0 versionnummer versionNummer  �w  l ���v!"�v  ! B <display dialog "neue gesetzte Versionummer:" & versionNummer   " �## x d i s p l a y   d i a l o g   " n e u e   g e s e t z t e   V e r s i o n u m m e r : "   &   v e r s i o n N u m m e r�w  �~  ��  � $%$ l ���u�t�s�u  �t  �s  % &'& l ���r()�r  (   set versionNummer to "002"   ) �** 4 s e t   v e r s i o n N u m m e r   t o   " 0 0 2 "' +,+ l ���q�p�o�q  �p  �o  , -.- r  ��/0/ b  ��121 b  ��343 b  ��565 b  ��787 b  ��9:9 b  ��;<; b  ��=>= b  ��?@? b  ��ABA n  ��CDC 4  ���nE
�n 
cparE m  ���m�m D o  ���l�l 0 filecontents fileContentsB o  ���k
�k 
ret @ o  ���j�j 0 neueversion neueVersion> m  ��FF �GG  "< o  ���i�i 0 version1 Version1: m  ��HH �II  .8 o  ���h�h 0 version2 Version26 m  ��JJ �KK  .4 o  ���g�g 0 versionnummer versionNummer2 m  ��LL �MM  "0 o      �f�f 0 	neuertext 	neuerText. NON l ���ePQ�e  P 4 .set paragraph 2 of fileContents to neueVersion   Q �RR \ s e t   p a r a g r a p h   2   o f   f i l e C o n t e n t s   t o   n e u e V e r s i o nO STS l ���dUV�d  U : 4display dialog "neue Version: " & return & neuerText   V �WW h d i s p l a y   d i a l o g   " n e u e   V e r s i o n :   "   &   r e t u r n   &   n e u e r T e x tT XYX l ���cZ[�c  Z  close access RefNum   [ �\\ & c l o s e   a c c e s s   R e f N u mY ]^] l ���b_`�b  _  return   ` �aa  r e t u r n^ bcb l ���a�`�_�a  �`  �_  c ded I ���^fg
�^ .rdwrseofnull���     ****f o  ���]�] 0 refnum RefNumg �\h�[
�\ 
set2h m  ���Z�Z  �[  e iji I ��Ykl
�Y .rdwrwritnull���     ****k o  ��X�X 0 	neuertext 	neuerTextl �Wm�V
�W 
refnm o  �U�U 0 refnum RefNum�V  j n�Tn I �So�R
�S .rdwrclosnull���     ****o o  �Q�Q 0 refnum RefNum�R  �T  , R      �Ppq
�P .ascrerr ****      � ****p o      �O�O 0 errmsg errMsgq �Nr�M
�N 
errnr o      �L�L 0 errnr errNr�M  - k  Css tut I  �Kv�J
�K .ascrcmnt****      � ****v o  �I�I 0 errnr errNr�J  u wxw Q  !Ayz{y k  $2|| }~} I $*�H�G
�H .sysobeepnull��� ��� long J  $&�F�F  �G  ~ ��� l ++�E���E  � w qset ersterText to "/" & "/" & "version.c" & return & "#define VERSION " & "\"" & Version1 & "." & Version2 & "\""   � ��� � s e t   e r s t e r T e x t   t o   " / "   &   " / "   &   " v e r s i o n . c "   &   r e t u r n   &   " # d e f i n e   V E R S I O N   "   &   " \ " "   &   V e r s i o n 1   &   " . "   &   V e r s i o n 2   &   " \ " "� ��� l ++�D���D  � : 4display dialog "erstes  File: " & return & neuerText   � ��� h d i s p l a y   d i a l o g   " e r s t e s     F i l e :   "   &   r e t u r n   &   n e u e r T e x t� ��C� I +2�B��A
�B .rdwrclosnull���     ****� o  +.�@�@ 0 refnum RefNum�A  �C  z R      �?��
�? .ascrerr ****      � ****� o      �>�> 0 errmsg errMsg� �=��<
�= 
errn� o      �;�; 0 errnr errNr�<  { k  :A�� ��� l ::�:���:  �  errMsg --number errNr   � ��� * e r r M s g   - - n u m b e r   e r r N r� ��� l ::�9���9  �  	log errNr   � ���  l o g   e r r N r� ��� I :?�8��7
�8 .ascrcmnt****      � ****� o  :;�6�6 0 errmsg errMsg�7  � ��5� l @@�4���4  �  close access RefNum   � ��� & c l o s e   a c c e s s   R e f N u m�5  x ��3� l BB�2���2  �  close access RefNum   � ��� & c l o s e   a c c e s s   R e f N u m�3  * ��� l DD�1�0�/�1  �0  �/  � ��� n  DJ��� I  EJ�.��-�. $0 logaktualisieren LogAktualisieren� ��,� o  EF�+�+ 0 
homeordner  �,  �-  �  f  DE� ��� l KK�*�)�(�*  �)  �(  � ��'� I KS�&��%
�& .aevtodocnull  �    alis� n  KO��� 4  LO�$�
�$ 
file� o  MN�#�# $0 xcodeprojektname XcodeProjektname� o  KL�"�" 0 homeordnerpfad  �%  �'   	 m     ���                                                                                  MACS  alis    t  Macintosh HD               ���H+  ;
Finder.app                                                     �@��        ����  	                CoreServices    �}�      �͒    ;54  6Macintosh HD:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��  ��    ��� l     �!� ��!  �   �  � ��� i     ��� I      ���� $0 logaktualisieren LogAktualisieren� ��� o      �� 0 
homeordner  �  �  � O    ���� k   ��� ��� I   	���
� .miscactvnull��� ��� obj �  �  � ��� l  
 
����  �  �  � ��� r   
 ��� m   
 �� ���  � o      �� 0 filecontents fileContents� ��� l   ����  � 4 .set homeordner to alias ((path to me as text))   � ��� \ s e t   h o m e o r d n e r   t o   a l i a s   ( ( p a t h   t o   m e   a s   t e x t ) )� ��� l   ����  � 0 *display dialog "homeordner: " & homeordner   � ��� T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e r� ��� r    ��� n    ��� m    �
� 
ctnr� o    �� 0 
homeordner  � o      �� 0 homeordnerpfad  � ��� l   ����  �  open homeordnerpfad   � ��� & o p e n   h o m e o r d n e r p f a d� ��� l   ����  � 8 2display dialog "homeordnerpfad: " & homeordnerpfad   � ��� d d i s p l a y   d i a l o g   " h o m e o r d n e r p f a d :   "   &   h o m e o r d n e r p f a d� ��� l   ����  � 2 ,set main to file "datum.c" of homeordnerpfad   � ��� X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d� ��� r    ��� b    ��� l   ��
�	� c    ��� o    �� 0 homeordnerpfad  � m    �
� 
TEXT�
  �	  � m    �� ���  L o g f i l e . t x t� o      �� 0 filepfad  � ��� l   ����  � , &display dialog "filepfad: " & filepfad   � ��� L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d� ��� l   ����  �  �  � ��� I   !�� ��
� .miscactvnull��� ��� obj �   ��  � ��� r   " )��� I  " '������
�� .misccurdldt    ��� null��  ��  � o      ���� 	0 heute  �    l  * *����   &  display dialog "heute: " & heute    � @ d i s p l a y   d i a l o g   " h e u t e :   "   &   h e u t e  r   * / n   * -	
	 1   + -��
�� 
year
 o   * +���� 	0 heute   o      ���� 0 jahrtext    r   0 5 n   0 3 m   1 3��
�� 
mnth o   0 1���� 	0 heute   o      ���� 0 	monattext    l  6 6����   * $display dialog "monat: " & monattext    � H d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t t e x t  r   6 G n   6 E 7  ; E��
�� 
ctxt m   ? A������ m   B D������ l  6 ;���� b   6 ;  m   6 7!! �""  0  n   7 :#$# 1   8 :��
�� 
day $ o   7 8���� 	0 heute  ��  ��   o      ���� 0 tag   %&% l  H H��'(��  ' " display dialog "tag: " & tag   ( �)) 8 d i s p l a y   d i a l o g   " t a g :   "   &   t a g& *+* r   H l,-, J   H j.. /0/ m   H I��
�� 
jan 0 121 m   I J��
�� 
feb 2 343 m   J K��
�� 
mar 4 565 l 	 K N7����7 m   K N��
�� 
apr ��  ��  6 898 m   N Q��
�� 
may 9 :;: m   Q T��
�� 
jun ; <=< m   T W��
�� 
jul = >?> m   W Z��
�� 
aug ? @A@ l 	 Z ]B����B m   Z ]��
�� 
sep ��  ��  A CDC m   ] `��
�� 
oct D EFE m   ` c��
�� 
nov F G��G m   c f��
�� 
dec ��  - o      ���� 0 monatsliste MonatsListe+ HIH Y   m �J��KL��J Z   y �MN����M =   y �OPO o   y z���� 0 	monattext  P n   z �QRQ 4   { ���S
�� 
cobjS o   ~ ���� 0 i  R o   z {���� 0 monatsliste MonatsListeN k   � �TT UVU r   � �WXW n   � �YZY 7  � ���[\
�� 
ctxt[ m   � �������\ m   � �������Z l  � �]����] b   � �^_^ m   � �`` �aa  0_ o   � ����� 0 i  ��  ��  X o      ���� 	0 monat  V b��b l  � �cdec  S   � �d - ' wenn true, wird die Schleife verlassen   e �ff N   w e n n   t r u e ,   w i r d   d i e   S c h l e i f e   v e r l a s s e n��  ��  ��  �� 0 i  K m   p q���� L m   q t���� ��  I ghg l  � ���ij��  i &  display dialog "monat: " & monat   j �kk @ d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a th lml r   � �non l 	 � �p����p l  � �q����q n  � �rsr 7  � ���tu
�� 
cha t m   � ����� u m   � ����� s l  � �v����v c   � �wxw o   � ����� 0 jahrtext  x m   � ���
�� 
ctxt��  ��  ��  ��  ��  ��  o o      ���� 0 jahr  m yzy l  � ���{|��  { ? 9display dialog "jahr: " & jahr & " jahrtext: " & jahrtext   | �}} r d i s p l a y   d i a l o g   " j a h r :   "   &   j a h r   &   "   j a h r t e x t :   "   &   j a h r t e x tz ~~ l  � �������  � , &set l to number of characters of Datum   � ��� L s e t   l   t o   n u m b e r   o f   c h a r a c t e r s   o f   D a t u m ��� l  � �������  � 1 +set neuesDatum to text -l thru -13 of Datum   � ��� V s e t   n e u e s D a t u m   t o   t e x t   - l   t h r u   - 1 3   o f   D a t u m� ��� l  � �������  � P Jset neuesDatum to text 1 thru 14 of Datum -- Anfang bis und mit Leerschlag   � ��� � s e t   n e u e s D a t u m   t o   t e x t   1   t h r u   1 4   o f   D a t u m   - -   A n f a n g   b i s   u n d   m i t   L e e r s c h l a g� ��� r   � ���� b   � ���� b   � ���� b   � ���� b   � ���� o   � ����� 0 tag  � m   � ��� ���  .� o   � ����� 	0 monat  � m   � ��� ���  .� o   � ����� 0 jahrtext  � o      ���� 0 
neuesdatum 
neuesDatum� ��� l  � �������  � 0 *display dialog "neuesDatum: " & neuesDatum   � ��� T d i s p l a y   d i a l o g   " n e u e s D a t u m :   "   &   n e u e s D a t u m� ��� l  � ���������  ��  ��  � ��� l  � ���������  ��  ��  � ��� r   � ���� l  � ������� I  � �����
�� .rdwropenshor       file� 4   � ����
�� 
file� o   � ����� 0 filepfad  � �����
�� 
perm� m   � ���
�� boovtrue��  ��  ��  � o      ���� 0 refnum RefNum� ��� Q   �A���� k   �4�� ��� r   � ���� l  � ������� I  � ������
�� .rdwrread****        ****� o   � ����� 0 refnum RefNum��  ��  ��  � o      ���� 0 filecontents fileContents� ��� r   � ���� n   � ���� 4  � ����
�� 
cwor� m   � �������� l  � ������� n   � ���� 4   � ����
�� 
cpar� m   � ����� � o   � ����� 0 filecontents fileContents��  ��  � o      ���� 0 	lastdatum 	lastDatum� ��� l  � �������  � 7 1display dialog "lastDatum: " & return & lastDatum   � ��� b d i s p l a y   d i a l o g   " l a s t D a t u m :   "   &   r e t u r n   &   l a s t D a t u m� ��� l  � �������  � . (set Datum to paragraph 2 of fileContents   � ��� P s e t   D a t u m   t o   p a r a g r a p h   2   o f   f i l e C o n t e n t s� ��� l  � �������  � &  display dialog "Datum: " & Datum   � ��� @ d i s p l a y   d i a l o g   " D a t u m :   "   &   D a t u m� ��� Z   �.������ =  � ���� o   � ����� 0 
neuesdatum 
neuesDatum� o   � ����� 0 	lastdatum 	lastDatum� l  � �������  � % display dialog "gleiches Datum"   � ��� > d i s p l a y   d i a l o g   " g l e i c h e s   D a t u m "��  � k   �.�� ��� l  � ���������  ��  ��  � ��� r   ���� b   ���� b   ���� b   ���� b   ���� b   �
��� b   ���� b   ���� b   � ���� m   � ��� ��� T * * * * * * * * * * * * * * * * * * * * * *                                        � o   � ����� 0 
neuesdatum 
neuesDatum� o   ���
�� 
ret � l 	������ o  ��
�� 
ret ��  ��  � o  	��
�� 
ret � l 	
������ m  
�� ��� , * * * * * * * * * * * * * * * * * * * * * *��  ��  � o  ��
�� 
ret � o  �� 0 filecontents fileContents� o  �~
�~ 
ret � o      �}�} 0 	neuertext 	neuerText� ��� I $�|��
�| .rdwrseofnull���     ****� o  �{�{ 0 refnum RefNum� �z �y
�z 
set2  m   �x�x  �y  � �w I %.�v
�v .rdwrwritnull���     **** o  %&�u�u 0 	neuertext 	neuerText �t�s
�t 
refn o  )*�r�r 0 refnum RefNum�s  �w  � �q I /4�p�o
�p .rdwrclosnull���     **** o  /0�n�n 0 refnum RefNum�o  �q  � R      �m�l�k
�m .ascrerr ****      � ****�l  �k  � k  <A 	 l <<�j�i�h�j  �i  �h  	 
�g
 I <A�f�e
�f .rdwrclosnull���     **** o  <=�d�d 0 refnum RefNum�e  �g  �  l BB�c�c    start    � 
 s t a r t  r  BK J  BG �b m  BE �  x c o d e p r o j�b   o      �a�a 0 filetype    l LL�`�`   ? 9set projektpfad to (path to alias (homeordner)) as string    � r s e t   p r o j e k t p f a d   t o   ( p a t h   t o   a l i a s   ( h o m e o r d n e r ) )   a s   s t r i n g  l LL�_ !�_    0 *display dialog "projektpfad" & projektpfad   ! �"" T d i s p l a y   d i a l o g   " p r o j e k t p f a d "   &   p r o j e k t p f a d #$# l LL�^%&�^  % 8 2display dialog "homeordnerpfad: " & homeordnerpfad   & �'' d d i s p l a y   d i a l o g   " h o m e o r d n e r p f a d :   "   &   h o m e o r d n e r p f a d$ ()( l LL�]*+�]  * > 8get name of folders of folder (homeordnerpfad as string)   + �,, p g e t   n a m e   o f   f o l d e r s   o f   f o l d e r   ( h o m e o r d n e r p f a d   a s   s t r i n g )) -.- l L`/01/ r  L`232 n  L\454 1  X\�\
�\ 
pnam5 n  LX676 2 TX�[
�[ 
file7 4  LT�Z8
�Z 
cfol8 l PS9�Y�X9 c  PS:;: o  PQ�W�W 0 homeordnerpfad  ; m  QR�V
�V 
TEXT�Y  �X  3 o      �U�U 
0 inhalt  0  without invisibles   1 �<< $ w i t h o u t   i n v i s i b l e s. =>= l aa�T?@�T  ? # display dialog inhalt as text   @ �AA : d i s p l a y   d i a l o g   i n h a l t   a s   t e x t> BCB l aa�SDE�S  D 7 1repeat with i from 1 to number of items of inhalt   E �FF b r e p e a t   w i t h   i   f r o m   1   t o   n u m b e r   o f   i t e m s   o f   i n h a l tC G�RG X  a�H�QIH k  w�JJ KLK l ww�PMN�P  M &  display dialog (dasFile) as text   N �OO @ d i s p l a y   d i a l o g   ( d a s F i l e )   a s   t e x tL P�OP Z  w�QR�N�MQ E  w~STS l wzU�L�KU l wzV�J�IV o  wz�H�H 0 dasfile dasFile�J  �I  �L  �K  T m  z}WW �XX  x c o d e p r o jR k  ��YY Z[Z r  ��\]\ b  ��^_^ l ��`�G�F` c  ��aba o  ���E�E 0 homeordnerpfad  b m  ���D
�D 
ctxt�G  �F  _ l ��c�C�Bc c  ��ded o  ���A�A 0 dasfile dasFilee m  ���@
�@ 
ctxt�C  �B  ] o      �?�? 0 filepfad  [ fgf l ���>hi�>  h &  display dialog (dasFile) as text   i �jj @ d i s p l a y   d i a l o g   ( d a s F i l e )   a s   t e x tg k�=k I ���<l�;
�< .aevtodocnull  �    alisl 4  ���:m
�: 
filem o  ���9�9 0 filepfad  �;  �=  �N  �M  �O  �Q 0 dasfile dasFileI o  dg�8�8 
0 inhalt  �R  � m     nn�                                                                                  MACS  alis    t  Macintosh HD               ���H+  ;
Finder.app                                                     �@��        ����  	                CoreServices    �}�      �͒    ;54  6Macintosh HD:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  �       B�7opqrstuvw�6xy�5�4z{|}�3~����2����������1�0�/�.�-�,�+�*�)�(�'�&�%�$�#�"�!� ��������������7  o @���������
�	��������� ������������������������������������������������������������������������������������������� $0 logaktualisieren LogAktualisieren
� .aevtoappnull  �   � ****� $0 xcodeprojektname XcodeProjektname� 0 filecontents fileContents� 0 
homeordner  � 0 homeordnerpfad  � 0 dateienliste Dateienliste� 0 filepfad  �
 0 refnum RefNum�	 0 datum Datum� 	0 heute  � 0 jahrtext  � 0 	monattext  � 0 tag  � 0 monatsliste MonatsListe� 	0 monat  � 0 jahr  � 0 l  �  0 
neuesdatum 
neuesDatum�� 0 	neuertext 	neuerText�� 0 projektname Projektname�� 0 olddels oldDels�� 0 zeilenliste Zeilenliste�� 0 	anzzeilen 	anzZeilen�� 0 version1 Version1�� 0 version2 Version2�� 0 
erstertext 
ersterText�� 0 alteversion  �� 0 neueversion neueVersion�� &0 alteversionnummer alteVersionnummer�� 0 antwort  �� 0 versionnummer versionNummer�� &0 neueversionnummer neueVersionnummer��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  p ������������� $0 logaktualisieren LogAktualisieren�� ����� �  ���� 0 
homeordner  ��  � ���������������������������������������� 0 
homeordner  �� 0 filecontents fileContents�� 0 homeordnerpfad  �� 0 filepfad  �� 	0 heute  �� 0 jahrtext  �� 0 	monattext  �� 0 tag  �� 0 monatsliste MonatsListe�� 0 i  �� 	0 monat  �� 0 jahr  �� 0 
neuesdatum 
neuesDatum�� 0 refnum RefNum�� 0 	lastdatum 	lastDatum�� 0 	neuertext 	neuerText�� 0 filetype  �� 
0 inhalt  �� 0 dasfile dasFile� 7n��������������!����������������������������������`��������������������������������������������W��
�� .miscactvnull��� ��� obj 
�� 
ctnr
�� 
TEXT
�� .misccurdldt    ��� null
�� 
year
�� 
mnth
�� 
day 
�� 
ctxt����
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
dec �� 
�� 
cobj
�� 
cha �� 
�� 
file
�� 
perm
�� .rdwropenshor       file
�� .rdwrread****        ****
�� 
cpar
�� 
cwor
�� 
ret 
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****��  ��  
�� 
cfol
�� 
pnam
�� 
kocl
�� .corecnte****       ****
�� .aevtodocnull  �    alis�����*j O�E�O��,E�O��&�%E�O*j O*j E�O��,E�O��,E�O��,%[�\[Z�\Zi2E�O���a a a a a a a a a a vE�O 2ka kh 	��a �/  a �%[�\[Z�\Zi2E�OY h[OY��O��&[a \[Zm\Za 2E�O�a %�%a %�%E�O*a  �/a !el "E�O `�j #E�O�a $k/a %i/E�O��  hY 7a &�%_ '%_ '%_ '%a (%_ '%�%_ '%E�O�a )jl *O�a +�l ,O�j -W X . /�j -Oa 0kvE^ O*a 1��&/a  -a 2,E^ O >] [a 3a l 4kh ] a 5 ��&] �&%E�O*a  �/j 6Y h[OY��Uq �����������
�� .aevtoappnull  �   � ****� k    T��  ����  ��  ��  � ���������� 0 tempname  �� 0 i  �� 0 errmsg errMsg�� 0 errnr errNr� �� �� ����������~�}�|�{�z�y�x�w�v H�u ^�t�s�r�q�p�o�n�m�l�k�j�i�h�g ��f�e�d�c�b�a�`�_�^�]�\�[�Z�Y�X�W�V ��U�T�S�R�Q�P�O�NFHJL�M�L�K�J�I�H�G�F�E��D�C�B�A��@�?�>�=�<��;�:�9�8�7��6��5�4����3�2�1�0�/�.�-��,�+�*��)��( �'FHJL�&��%�$�#�"�� $0 xcodeprojektname XcodeProjektname�� 0 filecontents fileContents
�� 
alis
�� 
rtyp
�� 
ctxt
� .earsffdralis        afdr�~ 0 
homeordner  
�} 
ctnr�| 0 homeordnerpfad  
�{ 
file
�z 
pnam�y 0 dateienliste Dateienliste
�x 
kocl
�w 
cobj
�v .corecnte****       ****
�u 
TEXT�t 0 filepfad  
�s .miscactvnull��� ��� obj 
�r 
perm
�q .rdwropenshor       file�p 0 refnum RefNum
�o .rdwrread****        ****
�n 
cpar�m 0 datum Datum
�l .misccurdldt    ��� null�k 	0 heute  
�j 
year�i 0 jahrtext  
�h 
mnth�g 0 	monattext  
�f 
day �e���d 0 tag  
�c 
jan 
�b 
feb 
�a 
mar 
�` 
apr 
�_ 
may 
�^ 
jun 
�] 
jul 
�\ 
aug 
�[ 
sep 
�Z 
oct 
�Y 
nov 
�X 
dec �W �V 0 monatsliste MonatsListe�U 	0 monat  
�T 
cha �S �R 0 jahr  
�Q 
nmbr�P 0 l  �O �N 0 
neuesdatum 
neuesDatum
�M 
ret �L 0 	neuertext 	neuerText
�K 
set2
�J .rdwrseofnull���     ****
�I 
refn
�H .rdwrwritnull���     ****
�G .rdwrclosnull���     ****�F  �E  �D 0 projektname Projektname
�C 
ascr
�B 
txdl�A 0 olddels oldDels
�@ 
citm�? 0 zeilenliste Zeilenliste�> 0 	anzzeilen 	anzZeilen�= 0 version1 Version1�< 0 version2 Version2�; 0 
erstertext 
ersterText�: 0 alteversion  �9 �8 0 neueversion neueVersion�7 &0 alteversionnummer alteVersionnummer
�6 .sysodlogaskr        TEXT
�5 
dtxt
�4 
btns
�3 
dflt
�2 
disp
�1 stic   �0 �/ 0 antwort  �. 0 versionnummer versionNummer
�- 
bhit
�, 
long�+ &0 neueversionnummer neueVersionnummer�* 
�) d�( �
�' 
ttxt�& 0 errmsg errMsg� �!� �
�! 
errn�  0 errnr errNr�  
�% .ascrcmnt****      � ****
�$ .sysobeepnull��� ��� long�# $0 logaktualisieren LogAktualisieren
�" .aevtodocnull  �    alis��U�Q�E�O�E�O*�)��l /E�O��,E�O��-�,E�O '�[�a l kh  �a  
�E�OPY h[OY��O�a &a %E` O*j O*�_ /a el E` OU_ j E�O�a l/E` O*j E` O_ a ,E`  O_ a !,E` "Oa #_ a $,%[�\[Za %\Zi2E` &Oa 'a (a )a *a +a ,a -a .a /a 0a 1a 2a 3vE` 4O :ka 3kh _ "_ 4a �/  a 5�%[�\[Za %\Zi2E` 6OY h[OY��O_  �&[a 7\[Zm\Za 82E` 9O_ a 7-a :,E` ;O_ [�\[Zk\Za <2E` =O_ =a >%_ &%a ?%_ 6%a @%_  %a A%E` =O�a k/_ B%_ =%E` CO_ a Djl EO_ Ca F_ l GO_ j HW X I J_ j HOa KE�O��,E�O��,E` LO_ Ma N,E` OOa P_ Ma N,FO_ La Q-E` RO_ Ra :,E` SO_ Ra _ Sk/E` TO_ Ra _ S/E` UO_ O_ Ma N,FO�a &a V%E` Oa Wa X%a Y%_ B%a Z%a [%_ T%a \%_ U%a ]%E` ^O*j O�*�_ /a el E` O_ j E�O�a l/E` _O_ _a 7-a :,E` ;O_ _[�\[Zk\Za `2E` aO_ _[�\[Z_ ;m\Z_ ;k2E` bOa c_ b%j dOa ea f_ ba ga ha ia jmva kka la ma n dE` oO_ bE` pO_ oa q,a r  d_ ba s&kE` tO_ ta u a v_ t�&%E` tY /_ ta w a x_ t%E` tY _ ta y a zE` tY hO_ tE` pOPY !_ oa q,a {  _ oa |,E` pOPY hO�a k/_ B%_ a%a }%_ T%a ~%_ U%a %_ p%a �%E` CO_ a Djl EO_ Ca F_ l GO_ j HW /X � ��j �O jvj �O_ j HW X � ��j �OPOPO)�k+ �O���/j �Ur �� v��v ��� <� < ������������������������������������������������������������� ��� @   D a t u m _ V e r s i o n _ a k t u a l i s i e r e n . a p p� ��� B   D a t u m _ V e r s i o n _ a k t u a l i s i e r e n . s c p t� ���  H a l t . j p g� ���  H a l t _ a l t . j p g� ���  H o m e b u s . p a g e s� ���  I O W a r r i o r L i b . c� ���  I O W a r r i o r L i b . h� ��� 6 I O W a r r i o r W i n d o w C o n t r o l l e r . h� ��� 6 I O W a r r i o r W i n d o w C o n t r o l l e r . m� ���  L o g f i l e . t x t� ��� 4 M a c r o N a m e P a n e l C o n t r o l l e r . h� ��� 4 M a c r o N a m e P a n e l C o n t r o l l e r . m� ���  P f e i l d o w n . i c o� ���  P u n k t . j p g� ���  R E A D M E . t x t� ��� 
 S P I . c� ���  U S B . i c n s� ���  U S B . j p g� ��� * U S B _ S t e p p e r . x c o d e p r o j� ��� , U S B _ S t e p p e r _ P r e f i x . p c h� ���  d a t u m . c� ��� 
 h i d . c� ��� 
 h i d . h� ���  h o m e . j p g� ���  i n f o . p l i s t� ���  m a i n . m� ���  p f e i l _ d o w n . j p g� ��� & p f e i l _ d o w n _ m i n i . j p g� ���  p f e i l _ l i n k s . j p g� ��� ( p f e i l _ l i n k s _ m i n i . j p g� ���   p f e i l _ r e c h t s . j p g� ��� * p f e i l _ r e c h t s _ m i n i . j p g� ���  p f e i l _ u p . j p g� ��� " p f e i l _ u p _ m i n i . j p g� ���  p u n k t _ r o t . j p g� ���  p u n k t _ w e i s s . j p g� ���  r A D W a n d l e r . h� ���  r A D W a n d l e r . m� ���  r A V R . h� ���  r A V R . m� ���   r A V R C o n t r o l l e r . m� ���  r C N C . h� ���  r C N C . m� ���  r D u m p _ D S . h� ���  r D u m p _ D S . m� ���   r E i n s t e l l u n g e n . h� ���   r E i n s t e l l u n g e n . m� �   4 r E i n s t e l l u n g e n C o n t r o l l e r . m� �  r E l e m e n t . h� �  r E l e m e n t . m� �  r I n p u t . m� �  r P r o f i l _ D S . h� �  r P r o f i l _ D S . m� �  r T a s t e . h� �  r T a s t e . m� �  r U t i l s . h� �		  r U t i l s . m� �

  s t o p . j p g� �  v e r s i o n . c� �  v e r s i o n . p l i s t
� 
cobj� s � X / / v e r s i o n . c  # d e f i n e   V E R S I O N   " S t e p p e r . 1 2 . 0 0 3 "t  � � � � � � � � ��
� 
sdsk
� 
cfol � 
 U s e r s
� 
cfol �    r u e d i h e i m l i c h e r
� 
cfol �!!  D o c u m e n t s
� 
cfol �""  E l e k t r o n i k
� 
cfol �##  C N C - P r o j e k t
� 
cfol �$$  C N C _ H o t w i r e
� 
cfol �%%  C N C _ S t e p p e r _ 1 2
� 
appf �&& @   D a t u m _ V e r s i o n _ a k t u a l i s i e r e n . a p pu '' (�)( *�+* ,�-, .�/. 0�10 2�32 4�54 ��
� 
sdsk
� 
cfol5 �66 
 U s e r s
� 
cfol3 �77  r u e d i h e i m l i c h e r
� 
cfol1 �88  D o c u m e n t s
� 
cfol/ �99  E l e k t r o n i k
� 
cfol- �::  C N C - P r o j e k t
� 
cfol+ �;;  C N C _ H o t w i r e
� 
cfol) �<<  C N C _ S t e p p e r _ 1 2w �== � M a c i n t o s h   H D : U s e r s : r u e d i h e i m l i c h e r : D o c u m e n t s : E l e k t r o n i k : C N C - P r o j e k t : C N C _ H o t w i r e : C N C _ S t e p p e r _ 1 2 : v e r s i o n . c�6 x �>> 4 # d e f i n e   D A T U M   " 3 0 . 0 9 . 2 0 1 2 "y ldt     ̎g��5�
�4 
sep z �??  3 0{ �
@�
 @  �	��������� ����
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
dec | �AA  0 9} ��B�� B  CD����������������������������C �EE  1D �FF  2��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  �3  ~ �GG 4 # d e f i n e   D A T U M   " 3 0 . 0 9 . 2 0 1 2 " �HH X / / v e r s i o n . c  # d e f i n e   V E R S I O N   " S t e p p e r . 1 2 . 0 0 4 "� �II  C N C _ S t e p p e r _ 1 2� ��J�� J  KK �LL  � ��M�� M  N����������������������������N �OO  C N C� �PP  S t e p p e r� �QQ  1 2��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  �2 � �RR P / / v e r s i o n . c  # d e f i n e   V E R S I O N   " S t e p p e r . 1 2 "� �SS @ # d e f i n e   V E R S I O N   " S t e p p e r . 1 2 . 0 0 3 "� �TT   # d e f i n e   V E R S I O N  � �UU  0 0 3� ��VW
�� 
ttxtV �XX  0 0 3W ��Y��
�� 
bhitY �ZZ  I n c r e m e n t��  � �[[  0 0 4�1  �0  �/  �.  �-  �,  �+  �*  �)  �(  �'  �&  �%  �$  �#  �"  �!  �   �  �  �  �  �  �  �  �  �  �  �  �  �   ascr  ��ޭ