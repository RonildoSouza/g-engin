#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich

 Script Function:
	

#ce ----------------------------------------------------------------------------

Opt("MouseCoordMode", 2)
#include <Misc.au3>
#include <..\GEngin.au3>

Global $scrW = 640, $scrH = 480, $fps
_GEng_Start("Particules", $scrW, $scrH)

; A personnaliser
Global $particulesParCycle = 1
Global $partsTailleX = 16, $partsTailleY = 16
Global $vitMax = 150, $vitMin = 100
Global $accelMax = 0, $accelMin = 0
Global $angleMax = 359, $angleMin = 0; deg
Global $lifeMax = 450, $lifeMin = 350; ms
Global $partsRotationMax = 1200, $partsRotationMin = 1000

; Choix de la particules: le fichier _File_particles_png() est compos� de 16 particules de taille 32x32
; il s'agit au fait du fichier de particules fourni avec le moteur 2D HGE
; (http://read.pudn.com/downloads192/sourcecode/game/904807/HGE%20Map%20Tutorial/Debug/gfx/particles.png)
; pour en choisir une, faites varier $partX et $partY de 0 � 3 (4 x 4 = 16 possibilit�es)
Global $partX = 0, $partY = 0

$img = _GEng_ImageLoadStream(_File_particles_png(), $partsTailleX, $partsTailleY, $partX * 32, $partY * 32, 32, 32)

Global $mos
Global $_maxParticles = 100, $_particlesArray[1][3] = [[0,0,0]]

Do
	_GEng_ScrFlush(0xFF000000)
	; ---
	$mos = MouseGetPos()
	_CreateParticle($particulesParCycle, $mos[0], $mos[1], _
						Random($vitMin, $vitMax, 1), _
						Random($accelMin, $accelMax, 1), _
						Random($angleMin, $angleMax, 1), _
						Random($lifeMin, $lifeMax, 1))
	_DrawParticles()
	; ---
	_GEng_ScrUpdate()
	; ---
	$fps = _GEng_FPS_Get()
	If $fps <> -1 Then ConsoleWrite($fps & @CRLF)
	WinSetTitle($__GEng_hGui, "", "Particles Nbr: " & $_particlesArray[0][0])
	; ---

Until GuiGetMsg() = -3

_GEng_Shutdown()

Func _DrawParticles()
	;Local $spr
	For $i = $_particlesArray[0][0] To 1 Step -1
		_GEng_Sprite_Draw($_particlesArray[$i][0]) ; Essayez de commenter cette ligne et de decommenter les autres lignes de cette fonction
		;_GEng_Sprite_Move($_particlesArray[$i][0])
		;$spr = $_particlesArray[$i][0]
		;_GDIPlus_GraphicsFillRect($__GEng_hBuffer, $spr[$_gSpr_PosX], $spr[$_gSpr_PosY], 2, 2)
		If TimerDiff($_particlesArray[$i][2]) >= $_particlesArray[$i][1] Then _
			_DestroyParticle($i)
	Next
EndFunc

Func _DestroyParticle($index)
	_ArrayDelete($_particlesArray, $index)
	$_particlesArray[0][0] -= 1
EndFunc

Func _CreateParticle($nbr, $posX, $posY, $vel, $accel, $angle, $life)
	For $i = 1 To $nbr
	; ---
		If $_particlesArray[0][0] >= $_maxParticles Then Return
		; ---
		Local $spr = _GEng_Sprite_Create($img)
		_GEng_Sprite_OriginSetEx($spr, $GEng_Origin_Mid)
		; ---
		_GEng_Sprite_PosSet($spr, $posX, $posY)
		; ---
		Local $vect = _GEng_AngleToVector($angle, $vel)
		_GEng_Sprite_SpeedSet($spr, $vect[0], $vect[1])
		; ---
		$vect = _GEng_AngleToVector($angle, $accel)
		_GEng_Sprite_AccelSet($spr, $vect[0], $vect[1])
		; ---
		_GEng_Sprite_AngleSpeedSet($spr, Random($partsRotationMin, $partsRotationMax, 1))
		; ---
		Local $ub = $_particlesArray[0][0]
		ReDim $_particlesArray[$ub + 2][3]
		$_particlesArray[$ub + 1][0] = $spr
		$_particlesArray[$ub + 1][1] = $life
		$_particlesArray[$ub + 1][2] = TimerInit()
		$_particlesArray[0][0] += 1
	; ---
	Next
EndFunc

Func _File_particles_png()
	Local $string = ""
	$string &= "0x89504E470D0A1A0A0000000D4948445200000080000000800806000000C33E61CB0000000467414D410000AFC837058AE90000001974455874536F66747761"
	$string &= "72650041646F626520496D616765526561647971C9653C000030CC4944415478DA62FCFFFF3FC330008C40FC1F8926073043F5FE23533F13057A91DDCF80C50F"
	$string &= "C8F2C87E84B9F92F19F681ED010820463212003BD4B3C88E8105DC4F3A44361B10F300F13B3C01496E2480FCF69B8C006586D27FA9909019702402E484869E58"
	$string &= "FFE3508F1C1EE86CB03E8000223601800286158859A098194B020079FE0F14FFA661626082BAE11711398A9C08E0859AFD83C444F997929C88C58FFF71940A2C"
	$string &= "D03066838A3141C39A183F33A1DB0710408412001B14B323B161898009C9D27F4891FF0B8A7F22B1699DF3A99DC04480F81B107F21520F3754FD7F0A72FD7F34"
	$string &= "31461C550A335222E080D2FFA199EE3FA9250C4000E14B001C4898139A08D8911201335202F88B14F93FA1F83B3417FD2031376103A0883704623120DE0F8D18"
	$string &= "5A260650229002E2CF40FC91805A166802F84846C4FFC753ECE32A1D98A1F6C1C21F14F65FA1E18FCB0E162C550618000410AE04C009C55C4898139A18D8F124"
	$string &= "809FD0C8FE0ECD1130FC1D8AC9CDF91A406C0FC42F81F80410F341C5F64113013B3450DE61292DC8AD0E40894019883F00F16B028993998C04802D9289712B0B"
	$string &= "343E60C53F37D48DDFB098CD068D745803F52F7A7B0120805870E47C4EA8C13C50CC8D940860A5007A02F88594F3616D0666344F9253128012D627A85BCD8058"
	$string &= "1C884F03F13DA488368616DB07A0B95607884D80780D341190D342FF07B5430BEA97677812C05732DB20FF09F0B199F507294CB9A171F20E475DCF088DCF1F48"
	$string &= "7CE47060040820162CB98D031AD93CD09CC68B960838901A8430C7C11A7E3FA029910DA99DC08054FCFC23A34D003247006AC62520168446CA4320D68546B828"
	$string &= "105F87560D4C50774B41DDC180E46966121B6A20B55781580F1A0E37B1440E1F5AEEE782FAF10F918D54F42A00BD54F88F250183DCA508C48FA0E1FE072DBCF8"
	$string &= "90CCFA81CF2D0001442801F0420DE383F2894900B0DCCF8414F87FD11A89B88A7A21A8FC3BB414FF0A88AF41D9208F5F04E2E740AC09C4FC407C1988CF43DD22"
	$string &= "02AD2A36A199436E23F21FD43E736809740AADAAE441F2932881006744EAC5302035DC18D1EA7866A488FF8325D1FE8126763E2CF53F1352BB80136A0E332E37"
	$string &= "0104100B5A578F1DA9EEE7462A05F8904A014EA44866446A81C28A7F16B4C887250E648CAD8B08CAB1F1D0A2762D524481DCA206C4D2D0D245045A272B01B130"
	$string &= "101F825609BFA125822F10BF05E2BD50FDB04465048DA0FDD01CFB174BAB9B11C9DDFFD172E609683BC409DAF680453817D42C05A8FB3EA399CB89942190C3EA"
	$string &= "2F8E419E7F509A0BAA8E131AAEFF904A015849CB0D359B0BC94C58A31464DF7B425510400021270056A42E1F7A22E041AB0A38A16A99908AF5EF5872FE6FA4B6"
	$string &= "C10FA81E561C0900D49039088D9C2F48B95611DAE0BB0B351B648E3A104742CD5E0055CF094D6C37A06EF480561920BD57A0F435A8DABF58EADEFF48832CAC50"
	$string &= "CC00B5E337D43F20F7B900B11FB4849187FA450E4ABF82BA431C5A32FD832688CF507B7F626900FEC332BAC70AB59717AA87099AD85F41D581E248166AAE30D4"
	$string &= "6C05681CFC476B9BFCC2D7360108201634362C0170A0F5026009811FEA282EA41141D808E03724F3FE61E915207721B1814FD05C064B506CD0DC0E32E318103F"
	$string &= "8096445C507780BA8477A01E928006400CB45E7C012D0DBE4373E91BA819F708B441FEA1955AECD0F6072752D17A0E9A08A2A1F67E84B64B40EEB78646E013A8"
	$string &= "DBDEE2A90EFE6361332155974C50374840CDE180C68308340CBE434B4171A4EAF80B34D7FF45AA3EF0364C01028805A9F867414B04EC68E300DCD0C8E7872606"
	$string &= "0EA446D50FA41C833C12C88165FC8005CAFF8925F07F20E57C6D20F68746E6366844E84273362827AC86E676756820FC84EA7B0E8D141168CE3C0F4D145C240C"
	$string &= "ECC07A36B06E2C13D4EF12D04007F9DB1D6AF72F684E045559C7A1A5CD5B6878B143E56189EA1BD2C0CD7FB4861E7269809C093E40239B076ABF01549E1BEA6F"
	$string &= "13A8FDA046B10CD46E46681C10EA61300004100BDAF8320B5A42801585C8D5020F524E6441F218035243F03B925E3634739991AA097C7DF0EFD0FAFA07B47DE0"
	$string &= "0F6D0B8012C27DA81B38A05DC05B40FC149A2058A111BE1A6A8E0034D0C490C60D4805FFA089EA23D42E2E68A350185A6ACD8526D46FD030F88A14F1FFD00661"
	$string &= "FE1118E8F98F9473BF22F56C5E40C584A17A93914A9C3FD02EF00902BD0F0C0010402C688D2026A4562872826045AB1EB8A039821529A5FD42CAE9E8F306CC48"
	$string &= "11CF88D6EAC5D61B5001627D68D7EE05D48EE350F394A081A80E4D2456D0C8B80FCD2D4F9012F02DA8D81B68C47F61A01C80FC90002DA1AE40DD28014DACC40C"
	$string &= "FC903230F5174BA23809C45ED046ED5BA8DD9CD03011825647EFD1BABD38ED040820262CAD605C9809ADA460456A8522E76C2622CDC337F0031BBC0901626FA8"
	$string &= "3DFFA1451CA82B16002D0DE4A011FE171AD9B7A081C0052D1665A1D5C50BA81CA5F312DCD09E0A2811CE8436321743FDEE42E2C0CF7F1212C27FB471065049B7"
	$string &= "01DA087D00ADE6D6404B4B985A5EA4194ED8801C2B7A1C0004100B9A63F0E17F687D7A5851F71BA9AF8A5CE411C2F84AA53FD0E2FA31D45322D0563CAC8FFD1E"
	$string &= "DAA863850E0AC17A2957A16AE5A181C2004D4CFFA810F99CD02E26A89B7A1B88CF404B0150E02E05E2506875749606B3944C48ED0331A8BF37404B4523E800D5"
	$string &= "6F68C2F8036D1BF040DDCA0615FB87548AC0AB1F8000424F00FF90A635D1A77791BB73DFD022EB1B54FC2752B7E90F52C2F88B9440F025003668CE568776B94E"
	$string &= "20F5E5DF42EDBB021D8C9182463407B491F81B1A18C7A109E40E527D2B8454F7C31A537748880050AEB38546EE0BA819DFA16C4568F5B30A5A5AE943078EF0E5"
	$string &= "6462E6FD9147F57E2155C1B099C7E7D00C2805ADE698A13D1166A89E4F48F47FA49E011BF2E0124000B1E018ADFB831491C8833CDFD0FAC7C8BD802F48133F3F"
	$string &= "91F4FE4233F72F9E71F93F488D9D4F4811062AC677411B7AECD09C0ECA7DCE40EC06C476503325A0F436A4710735A489A32F50B621090980135ACA5C81DA2F88"
	$string &= "3439F4122D327740138A26B46D40A8586724A28DC6044D64FFA0117E1F29034A42FD710CADDDF0029A507EA2F5347E43E30CDE100508205802F8893490823CA5"
	$string &= "FB03AD558F3C84896D1CE033D491C853C13F914A863F48E303B85ADBEF90225F151A61FBA10DB9CF50B133D0C8D48216F977A089E20BB42AD0476A95FF84168D"
	$string &= "5FA0763F22A1A5CC8614C81FA0FEFF8ED64A471FA33F02C416D091CBA724D4EDE8D5036C0AF70D341C39A1E1F20B2DC37C83F674FEA03572BF62698FFD472A85"
	$string &= "C1620001C48266D82F2C53BAEC68C3BB7F907217FA4820ACDBF2156D2AF8075A2220D4E5FA0535FB25D2000713D2E0106C710A1FB411B40E5A5DD8417B10DFA1"
	$string &= "66A84073E361A4807B038D4C627A48FCD0A2F63B52242127DE27D01201BD143B8E3410F58EC8AA00DD6E58C31A369EFF01CB20DA7768A2E046CA68BFD1C2126F"
	$string &= "58030410B281BFB14CE9B2E118DEFD8E672E0096089013C277B4F601B17DEF776855C135685FFC05547E2310BB42E7ED774323C40DDAF8E180AAFB8F1609C434"
	$string &= "0899A1FADFA3359CFEA2E5D2AFD09E08B6EEDB6568D1FD0DCF34F87F1C6B021891AA6458CE6764C05CF5F3196ABE340362591AB1006C0E40002127809FD04845"
	$string &= "1EC4C136B1F39388E9E02F5047634B04A4AC1584A56058C3F0383447FE8046F22A285B18AAF62C3472DF40EDFF83A5D824A6AFCE0C75F33F02DDB69F7812F45F"
	$string &= "E8E89C18B401FB83C85E012C43C1C2F833525F1E7D68F7375262F9C040C6AA648000425F11C486652A989CF500B052E03334023E23351249ED8E31415BF1B250"
	$string &= "FB14A16D827750F7A842DD729901B1581296CBC9E97691B266801B3A2670154FE0B340AB890F488985D0327058E313BDCD810E3890D4703290B106132080D0EB"
	$string &= "945F688339C839FF17D27C3FA11541DFD0AA025831484E5FFC1FD2281E6CEE1DC63682B6FC0F23158F3F89EC62E14A6CA414A3B0B1100602035BB0C99C3F58E6"
	$string &= "0018B1AC17F88B54DD122AAD7E23E92179593A40000D853581E811044BB4A0DE8125B4BB7592813E7B12B045802434827F12A9FE3F013E4C8C19ADD58ECD2C4E"
	$string &= "24796668D8FF23C11D8C000134545605C3AA271EA4616221E820C83D2A8DF1930B0491BA9B94262646B4C9A2FF04D4B32185CD0F02632C58130140000D957D01"
	$string &= "E8033AEF1888DB20420FC08BE4577223FE3F91ED02F4D2F03F52F8FC22A1CA83DB0110404365671013036265D29B4110E9E825E53F2AB989D0DE406C0900DF52"
	$string &= "368200208086E2DEC0C106D8901AD0D46A57FC27411D0B5AA3F21F29090C20801887C9EEE08104B0E9F19F344800F812032303FE452544252E80001A4D00D489"
	$string &= "30562A97000C44B607B0CD2A32E2A842B09A03104003990038193037350CB58867438AF8FF34B4E73F15D8580140000D540210848EEC5D67207E6E603002D8EA"
	$string &= "DCFF744A70F87613FD2794DBB1018000424F009C541AB0C10740CBB44173F9A0E1D3D743BCF8E746EA7FD3B3E461C0D27524EB84148000424F00A0756DA0850F"
	$string &= "2F68E478D05225D0B2A90B0CB8375B0E25C007CD3043B614030820F404A0028DA0A30C90A9556A02D0824E6B1A993D5000341AF995CEDD5FD8C25C262C55016C"
	$string &= "6517D1B382000184AD0D009A6D03ED7F03EDAD7B4025472B3040966F8146F1EE0F40638D5675346C1AFA3D1DFCC0C480BA021B7D7F05F27A4ED8601CC1AA0920"
	$string &= "8070350241C3AE9E40BC990132D64E09004D978256D36E67802CCDA636E061C0BD2397DCBA919D01B1B51A1FE08596020FC9C8C5A48CD9C3F665206FD6412E05"
	$string &= "90733FF25A4CD8021C9C7E0708207CBD00D052AA4006C87A7372230E9490406BFBD733105E24492E486080EC8A7940E51C27000D3C7C134DFCD0DECC151273F2"
	$string &= "5F12120AF2861CF48D37CC486A91733EF2D23ED83C05D60407104084BA81A09336A21820EBDEAF921888A0963E6803E5321202889CDCBF035ABA80366ABCA172"
	$string &= "2210830620AE3584A044620AC47B18F04FF322D7DD7F881CD8816DEA806DCBE3444B04B826E4D0D77522AFC9C4B017208008EDD103451C688F5D0603647F1DB1"
	$string &= "C000AA67350D231F046CA0F53068C3A80495CD0605D62B684B5F18879A3FD05280114F443240230C79EE9E18C08AA40F7DAB3EFA967D5E2C72E8C7FAB062B304"
	$string &= "2080988870086887CD12202E6080ACA727040CA16A97302076E7D00A04437B17A08420CF807BEB39258900B4B45B125A1AA003D82A274EB43065421B2BE02172"
	$string &= "BC00F99C025606D46DFADC4834B6731B7890E4B8D0120007036215170A000820262203E224B488AD64806C47C6054CA06A6642F5D012A8404B1A1E28DF9306A5"
	$string &= "00AC6E05ED0B50852604743911684310B901F917A99B0892FF4C64BDCF8896FB91CF6A806DCAC5551A20E77A2E347DC86D07140010404C2404046845EE24206E"
	$string &= "62802CC542079650B94950B5B406EE4811FE1FA934A00500E55ED046507DB492E03F5211CBC0803833E13FB4440235109F93305004CBFDE83BB2D1CF6A404E04"
	$string &= "BC588A7C0E06CCB319D057798301400031911810A05D2FDD506C87246E87247E84CA8DBC7606C89031FAE6D2294811CE084D0CC7B1A8036DE40C472A29C805A0"
	$string &= "5C7C025ADD4821897340DB090C0C88134D74A0DDDF9B0CA4CF12C2FAF8AC68DD3FF4EDF9DC38723F728EC7D67544A906000288B9A1A181D4800075B740C3B85D"
	$string &= "D088017517DB80B801DA1AA626F8051D9002ADB9D3430A686201A88790C5803868821A2501C8CFAE0C88E358E4A0810A12076DD0006D571387764DC9B19315AD"
	$string &= "E8E744637322E5744968C2E7401A8D44DFC58D7E4817CAA963000144C96CA01FB4AE07817406C8A149B404A0967E33B4DE27A6B1D709C413186833AF01AA0640"
	$string &= "F3263BA16C58034B1F1AE91B18C89F54E3402ADA616732616BE583121B68B38C2834F1DD843658BFA061D821551F1910FB33E0091320802869350B21355A84E9"
	$string &= "50E7EF8036C64091EA0C0D286C0014E1A5D048A0D56AE157D0C80745D063A42A08B439E51C03F9F706606B1022D3C807757043235F0FDA3E79C2807940073673"
	$string &= "50004000919B001C8138173ACAC7006DF83D6020EE98144A0028012C80A67C151C6AD6428B5F6A473E2303EA0EE9770C88B388FF41AB296A4E0BFFC742231FD4"
	$string &= "F1159AF32F41E9AF0C980774603307050004103909C01ADADAAF406AF09521891DA5712230808EC0E102FAD09CF98481F825558C687D7858BDCB84D4806285B6"
	$string &= "4144A06A2F43733F6CAE811F5AF7C3F6E77F253341A09FC682EDD00E505DFE12AAFE09D4AE976875FC5F34FDFFB00D44010410A9090034C85305C4350C90133C"
	$string &= "60600FD472981C2D0780AC912201562A4820B5F241AD7405689DF887845CC68816C89F918A7226685D2FCC803895137610F37F68E29087EA0185A932527DFB95"
	$string &= "C4D2017D560FFD9416E43980A70C8889A5DF0CB84F69F9839620E0002080484900FAD09CDE82A39F7F106A31484D0703EE6352281DFA1585B241810B3A9EAD07"
	$string &= "9A204076DA432305F93817528B5C189B05A99E1561402CFC3C033557105A528841DB04A01E01E8C4B2CDD0C8E744EA7AF13220F64FFE2190186011853EAB87DE"
	$string &= "8FFF8BC4473F981379530EF2492F18FB07010288D85E00A8A1910F6DF59F22A0D60CDA2B9808AD9FA8097280B89C0132E95389D6D5029500A0B3F34AA0ED914C"
	$string &= "06D2E7215890FACEB0411DD84657E4FEBC3434E09F41DB43C7A0EA54A0FE071D51F301CBA01B13529B01DF8159C80776C33017967E3EAE0DBAB05DDADFD07A04"
	$string &= "186715000410310940031A98A0B1FDD344062468860C746CEB7406C8F12CD402B3A1913F9501F7AA2203E8E0512F3481FC2132E259D11A5AB866ED84A1EA5F42"
	$string &= "EB7D4D06C461560CD0C1294368FBE83D11ADFCFF3806833891C6F6619803695C9F154B02809518B0FD985FD1F077F412002080082500508A4E6080CCEA915AA4"
	$string &= "83AA8C5068ABFD0E15229F07DAF87B43C4000B296A893DB18B8101B1671F7622B8143422D01784884333CE2506D2570B3122F53890C7FFD12FECC0B51E007D9B"
	$string &= "3EF20E6D8C51498000C29700404399610C906358C85DCC01CA1DA0235E412779DC6318DA00DB620E506EFFC48038C606197043FD0F5A02F7964CFBB08D085275"
	$string &= "3D004000E14A00F2D0913ED06007A5CBB840AB82DCA123850F19860F802D1879C7807BB2871DEAFF470CE4DD2944F315410001842D01801A38A08396401731DC"
	$string &= "A5526081BA45A00923D8597FC301C00E64FC40A0EA0045961CB4A7F0998201289AAC09040820F404007228E8E0E593D0544B4D0033FB10D220C65006B048F94A"
	$string &= "646291809616DF294870545F150C1040D836865C63A0DDA60D49682BFD0CC3D0DF15045B5C41EC5C3FEC54932F0C94CD4C52755F004000A127006E2253342500"
	$string &= "D4425687F6D1DF0DF10440526033A0DE05342836C50204D0406D0E158636346F93592F0E06C0424124229FE03DA000208006727B38ECC2897744E69CFF14C8D3"
	$string &= "AA17805CFC92EA86817033060008A0A1704004AC3FFC83408EFA45C70847BFF802D7D4EDA0070001446C026064403D1CEA2F03EAE284BF0C881344191810AB5A"
	$string &= "38A183209F1910B3557FC8081C2E06FC974EC22E67A255A0635B64812F01FC4363531BF0431B943CD078F9011D67784F6A2F0320807025002668A0FE471A8C10"
	$string &= "84462CF28818EC0E3B06A4C4008A2C45681D0F72E83D689712342CFB049A207E319036578E7E39347A5D0CBB4CF22F0D723DF2240E3352718F7E9AEA7FB42ED9"
	$string &= "7FA4011A062AB80D34B40DDAB90D9A11059D442E0B0D5F5802780B1DB701AD48029D9C7A9598360A4000A12700D8B12742D03A9A0929F7C36EA88445F82FA462"
	$string &= "1936660DBBB401E4507D6809001A497C001D007A0A4D104FA0DD215272076C30E50752A4C04ED306F52C1E1319C8C46ECC448E746624367AC2C07615CE5F2CF4"
	$string &= "1FB452825800BB0413B4CDCE121A37B013DB7F236552D850F17F6886036D975B02ED72E3040001044B00B04886CD4009410DE3452A66589112066CC409766F2D"
	$string &= "AC7AF8036DE18336881842F55C8746CE2B68E4DF84D26F49CC15A250BBEF41ED0225C46F503150697303C92DFF7044323167FA3122453623D2000C3352C4C3D6"
	$string &= "0BA01F93C78454C5C1FAEA5F91228AD46E23A8BB0CDA6515068D07D000DA0B06C475F1BF90EC6287AA11868EB70840C30AB47C7E11038EA168800062416A4471"
	$string &= "3220EEE26385E66455680073402340960171241A23D4D057485D9AF70C88039B3F2089FD45AA52FE3210DE218B7E6C2A03B4F85782961EBFA1EEFD863422F717"
	$string &= "69C4EC2F8E6A848501FF5A41E4ABF31819506F4263C39100908B7C46A4D139D80D2CB01B55FF92D84804E5F65606C8229797D001BA97D0F0FCCC80D896064B00"
	$string &= "B093DEF9A1250068A652056A06886EC336020B1040C817477230206E0585DD9409DBF6044A4D3250CC8554E47F850EE83C873A0CD6107980E4B0770C88AD51B0"
	$string &= "A3E5BF12E806C1965921F795617713C1C60F601756F02199857C2D1AB2D92250FDEF09B4F0918B7CE4E156E4FB13914B0816A4440D4B08B0B97C3668BB8715A9"
	$string &= "546062405DB38F0B80AE9CE98796A4A02AF40E7474F62D03627937F2240F0B5226E685B6D7DE42FD0B9A96CE8266805AF411588000422E01409AA4A101FA8301"
	$string &= "B1F8E02FD472D88A1231689D0BBB449A8701B15C0A5614BE6140DCDA09AB9F60B3679C44E4005840C12EA6842502D06CA2293440581810BB72FE2015F13F1950"
	$string &= "2F4692848A3FC612E1C86E60462BE661118E7C5722175AA260454AD48C488D5B71686E433EC913560A10EAAD801AD08D0C909545971910B7A2BE8066A68F0C88"
	$string &= "154AC8098B15A9F7F501A9948065BC046869DD825C050204107202608796007C50C3C4A10982155A97DC80E66C5968F520C180B815E32303E222296E06D4D928"
	$string &= "0168C4C35AAAB0D48ADE1843E6FF436A70B1312026363E403D2DCA80BA40F22D524243EE61C841FD710529926045F76F1C250017340C6076B221D5B11C482524"
	$string &= "B60400BB7C8B1D9AE0D890868DFFA04518B6635D41FA40ABAF5CA0A5DC6D68F83E83E65C58690ABB7DE51F52DB830529FCBF42C31BD98FA0BB15404BF5406B25"
	$string &= "37C2040102B075C628140231101D153F88CD2FBC828507B0F2FED87A09FD3616168222C24798218358BBA8896F938D6C7604C04AA76E36ABEE50DB20D4A87E88"
	$string &= "CE93898E923125E1292CEC4B7AA64274C8C2D2CBF370A594EFB01B50B9C172203A75A598A9235A66849894D61735C70D0871EB8FC189973F7902E3E47D2F3E57"
	$string &= "694F76E6562A3F851DBEFC68858D51BEF652F2AD1AE9B8DA5F68E748BFCF08B12B6DED72D0139B58BA761A1C196D680941CF6880BF0042BE060E76DBB7005277"
	$string &= "8F0B2957C01623FC441AD8618106146C63220B34F2989122F219540F6C050BECE67136B404004B6872D0B6C643281F79FEFB0734501418100B24C4A13D0D7568"
	$string &= "60813CAF03C5208FC26ED5FA0F0D9C7F04067A9818103782C3969B7F61405C98CD83348CCD8954A7FF8486DD17A85DB0ABDC608D6066A4AA8909A9DA81352041"
	$string &= "FE09859696E7A091FE1229E7C32ED0FA8634A0F617ADEDC2CA807A37233352A9C0076D4083562E8316B2AE0469040820E49B436145381FD4811FA14510070362"
	$string &= "6D1DAC710563734003EB315211F719A9E5FB1DAA9705EA312E684BFE2D34B2D0C15706C465CCA650B3AE413D04BBBFE81D34F50A213534C5A1E30E2FA1451D28"
	$string &= "276D85DACDCD805816855CDFC38A606CF723C34A918FD01CAF0F8D083E281FB6219305CD0C4E68BF5B089A205E3320167420576B4C686D1B5897CF119ACB5F20"
	$string &= "35E23E40F12706C4E24EE465DEE809E02FD2482D72BB40009A7940990B74F9346885D67780006241CB05C8F7E3BD46AA123E21452A721DC88B14E91F9112D30F"
	$string &= "A4FAF93334D2BE412315763BF85B06EC6BE918908A3CD8EDA0B7A1812007D5FB029A90BE4213AD27D4CD3A503DEBA1EEE1406A30C1C639608DB16F6891C784A5"
	$string &= "246084BA1164960103E28632D8855A3C503FFE86DAF51C1AC0B025E3CC48D50472E9F2074B03D408A9E47BCF80586B887CE1D637A4D63F7A57F70F5A7714D626"
	$string &= "80B9FF03522962042D45AF030410FAC591B0460F0B524302562AC00C16472A6A04A172B0010A585FFB1D522B941BA965FE1F9A3B14A1A5C62D1C7D7E987B402B"
	$string &= "91EF43738704D45E4BA85A58C204E9758236F440F53E6C63C62FA404CD8594FBB05DEFC288D6FA473EA00156AFBE820E6EC1FADA2AD0C4001B00FB08F5372F03"
	$string &= "620B37F22CE11F2CBD1F46A4768336D4DE0F0C885DBDC8176F226FF4C03586F21B2941C15606235FE2F5096A3EA867045AA6771D20806009800F69728107DAA0"
	$string &= "926540DC42FD161AC93FA0910ECBD97CD0D4C40A359C07EAB807D011BF97500BF9A17ADF21F591D990BA2FC8CB9D5890EA6A585D7C1E9A6261B775FB43DDFB09"
	$string &= "9AD30CA10DBE8348630E7F91BA607F901A91FFD0228019A9A1843CF0036B547120356E3F43C3441B3AD0C282D6829781E65E3106D45BD2FE61B117B9E721082D"
	$string &= "DDFE22358EB1EDEC21B4AB0879D819F90A1FE46B80BF401300F8700D8000827940161A99B0225E175AC4F22215C967A08E636140DD84C082D46EF8CE80D853C7"
	$string &= "CF803840890D3A3AF51669040FB69BF527521F9A15A94129C0807AE0D25FB47EB011545C0F29119F40EA6B231F45FF1747DF1BD7B5F68C68FD7F98BB1891FC8B"
	$string &= "BEAD8E071AA84F90C2E01FDA441923160C1BEF1740EA51FC426BC9FFC533BC8DCD4FE81B4A61FA610982199AE81800028805A93BF8039AA3DE40234A980171A6"
	$string &= "FF73684EFE058D84F70C88D3325E21D595CFA06AFF40738E083437C0460EBF41F5BF61403DD8F13F528AFD8E94E818905ADBEC50F93BD0BEAC08B49B0A0317A0"
	$string &= "18B6F68E0529E53360A9FBB125827F48F80F1A46BEA0890DCFC48D3034FC0490FAEA5FD1461759D0FAF04C04D61690BB7601DB801BF2AD640C0001843C0E2008"
	$string &= "8D58D800C67D68207F87B61E7F23A9FDC68058117B1329E7C3FAAAB01C270ED5230DADC39F42F53C6420BC28941929E1C0FAFBA0625E0B5AD77F81BA5504A9B8"
	$string &= "958096022FA1EEF98FA5D5FD8F40EE412FA66123805C48631DB8F4C2FAFA120CA86BF139915AF59FA099E00F927B6037AF239F41C086966890E719889DC646AE"
	$string &= "D61891E60CFEC11AE00001C48234B5CBCA80B89F9E0D9AB3EF2039EA3FD4A17CD006840834505F20A57821A4060C6C30E70B3441C0EE2278066DFCFDC2D11F87"
	$string &= "B50778900660608D9A7B485DB1A3D059B217D084F50F6A4702D4DD6790DA21C4DCC0C9883456C18C54F2B0210D10FD6440DC18AE8856127C84BAEF163413C0D6"
	$string &= "40BC47AABA7EA0F5026009EE3D345C5891FC0C1B9D45BFAD8DD074360B5AD5857EC01437D40DE095DF0001C482D432FE8394085E423D2908CD7DDC480331C2D0"
	$string &= "C90A7968C43E8246C24FA42EE17D68110F9BB87804B5EB19D46C66A4717EF40619AC350BEB7A3220AD421286DA05AA0212A1629BA1E6F241ED7A056DA17B41C7"
	$string &= "036043AAF7A101FD0F4B4E61441B5163452A357E208D67C01AAC2FA17E15411A7A85F9F9173443C046EDBE210D1523CF2622971CEFA143EDB0F10EF423DF60C7"
	$string &= "BDFD26309F000B577606D46366914F1513409A9A6700082016A46E121B526AFF0E15FB8D540F7340234004A93E6543EBEE0823CDDB334023E629340260AD5376"
	$string &= "06C4010F4FD102E2375231C588546CFF471A693C0C6DF8194357BD6C837AEE19B4AA79036D0B70437B0E825037F120B551BEA1CDE0B12245FA1FA47603F211ED"
	$string &= "7FA16E90870E56C14A287168E28735723F4323FF0703EAFEBC9F48ADF8FF48A380307F9E85468C28D29C0C6C3DC6372C033FE8AB8A5918504F18433F4B900F1A"
	$string &= "16B0D2137C6C3F4000C112002F5242801DBE0473FC73A4225E0A69740A56AC7C8116B99F914A0DE405223F91C61460A75EC1BA904FB14C86A08FD723B7C61F43"
	$string &= "DDE888344AF80269DCE2255217EC27D268A318921A26A4913946B4451CFFD0563C3121954A7CD030388F1441B0A25F001A46EFA07EFA86340E817C28C45F06D4"
	$string &= "933B907B2757A0ED97206822780335FB0B52E2F9875452FEC63217803CF2073B654C001A27B0852220FB76C106EE0002B06D76290CC24010966A91F820BEF9E6"
	$string &= "31BC8267EE8D1449A1FEB43E482AC22C7C841C6009D9C0ECCCECA448E85493690B922C66E2D418053F101F0FB66B5BB10FCC8880597E467E7806DD1D10D82079"
	$string &= "792060D2EB1C2FC8FD42EA19549770097365E51CE4DB1631FF27A0D9EE6C49E35D4D6CF4404EF5B3EA4621CD04A76D4D1837947329E979D7DCBFA807F18B37CC"
	$string &= "A033DAFA1D2099FF68195421136088DD8A987642C79735FE12402C48B9FD1FD26A1E98C5C8ADDEFF68A98D0729A78B21E5967F48753FF29C3E27D2122906B4B1"
	$string &= "F9FF48399E194BB7E80794E6867A127680F31BA406E607A85D9F9112ED77A48999AFD02A801D69DDC01FA488FF8554FD30218D21C01A9DA7A1FE15441A6B6741"
	$string &= "9A37804D777F436ABF20EFD5FB8786B14D07EF818ED1C740CDFA8E65CE9F1D6D36F01F9A1C17D2C09E04349C4055A31A54ED5CE42E384000C112C027A462EC23"
	$string &= "54E10FA488804D327C42B28C0F6A01F28A9CAF488345B0DCFF0E69050B1BD298F6472CDD2F66B4C596E83B5B05A0D5802CB4D1F40A6974F22FDA3A3C4EA4E561"
	$string &= "1F906636BF230D3E21977ECC0CA8AB9D99908AD18B48D3DEC84BE49991EA7001A4AEED67B491C0FF68DD505CDD5150F84E824E3E6920752B19904625B990AA98"
	$string &= "DF381684F043733E6CC44F155A7DCF67801CA307070001E83883140041208A1A8121D425DA77C7961DB608A120893082197A8A9E40177EE7FDF13B7A000EB137"
	$string &= "3DA8DF8184836CAEC5D57A81CE5B934EC3D230C2063072A8D367C10632615B6A796A29589101F099DF7E601903D4DCC91E2CD41F2B1DB4DBFCDFB01B0158AA3D"
	$string &= "A06468ABD9CB1A3B002D40FDB100B5352BF7C1E02C91B0C9A471FB01EE221F3F6F91D0D2108E2A7F94D7D1C564B38B5E0184BE2C9C05A9E8E045CA45FF908A3F"
	$string &= "012C8B49D9901A6FFFA1817D0F5AF7FE46AA1E60B37CE46C0E6147728F3234401F438B7521A4B60323DAC4162BDA7433339E086042EAFFC3A691199116853223"
	$string &= "F58A1890DA2D4CD01CF602A9A1F91D6D5C9E0169E89BD0C511203B43A0CBB794A061F900696DC01706CCF37ED8D08A7FD8848F18B4A754C580E5D02C8000C2B6"
	$string &= "31841D6A8014B42881CDCCC1225218A991F5071A504C48336EB021625844C302FC13521D49CE6E192E686EE78136927E224D52F12005342B525F990129E7C296"
	$string &= "827D2510F0B0C1989F0CA8FB22D8D07A25FF911200AC7AFA0D2D0598901689203700914B38620068961374EC9E03D2629857D012E73BDAAA1FD8B2704168E44B"
	$string &= "42130A686FC004061C772A010410AE9D41BCD00480BC00127DEDDE6FB4E14646B4D9A8FF680B2B3E5010F9AC0CA85BD0A491E6C93F31A01EBFC6C580FB760E36"
	$string &= "A4717E42C3D0CC68A50213DAEC217202F88FB43EE23552A4FCC43199434AE907AAC323813802DA2E80B571BE20253016A4D54A5CD0B0011D5DB7009AFB716E17"
	$string &= "0308205C090056A4FF471A3EE4421AA0F9876348F23FDAD02AAC47F19981FCB374619B437F212D721081E6FC9F58CCE4406AD5FFC761DE7F22EC445EFECDCC80"
	$string &= "B9610479E93A7222FD89360B89F3985612016CC5903D3421882275AD619B749E401BAC7BA0833D040FE1000820429B43999022969701F5BCFE9F48C50EFA3834"
	$string &= "ACC87F85541493BB979E05A931CA82343EFE8B01FB024F588EA5C66D9E8C6891CFC0807A3013F29A7F162CFD7C0606EA9F03C085D4BD1380BAE13B34B25F3020"
	$string &= "36EA1005000288D4EDE1E8A752B120550FC875E55FA43602A53B76D9911A97B07577BF08E42A163C6B00C84D08C8250072B7F51FDA14EC5FB40430E08740E003"
	$string &= "0001842F0130E22936D1AF2AC737D181EF48D45130C0002080702500F485918C0CD857CF3032602EAB6262C07EE4F9FFC19E1B4622000820E40480BE3F0EB9F5"
	$string &= "CB84366A863C9FCD8254F4B3A01585BF910692A8D11022544453B28A6644028000424F00C8AB46900F26469EA7FFCD80BAA801B6DC1AD638FB8F9600BE224D8D"
	$string &= "52B35E66421B416460C07E60C36862C00300020839013021453E6C27096CBB380B03EA99F4DF91265A608905B9AF8CBC1F1EF9D2845F1424022606D4992F06A4"
	$string &= "D289192DF2FF200DB8FC1B4D08B8014000A12700D8250982D021444106C4FCF87F06D415ABB06E18FA60D13FB40121D816B12F48A50031BD0346A4C124E4A5DA"
	$string &= "C818B98482B5CE919740FF60405DD4399413810B096AEF3010799B3A4000219F10823CCB270EED670AA18D76FD421BD8F887D620443EB5FA2F5289011BB1836D"
	$string &= "74F843447B007918167D950B6C708A9B017379366CC1236CF5F26706D499B3FF4334F27793A01E347CDC4D8C42800062C1D3FA87AD7F6367408C8BA3F78991A7"
	$string &= "4FFF21F5CF6173078C48C3AFE83D015C8900B92D823CBB25042D91FEA399F5830175F52F130362F5CE4B06C4A91A7F19A87F88D490070001C482A5CF8E7C01D1"
	$string &= "2FB4F100586E446EF8FD476BF1C38ADE9F48B98E9701F58C1C58F710D7AD19B0BDFEB0492961A4D2E40F03F6ABD1D07B316CD0920CD626419E9CA14629001B0A"
	$string &= "6766C03C218CD60094C33F4013791716F9D5C41A041040C8BB8399901A4EB09D3BEC48A371C8A764C072186CCD00F2F5A4B0E2FE3B0362D20236A7807E8111FA"
	$string &= "783DAC546167401C4B23C080585FF00F4F318E1E09B0881063403D3081D25200D6E681CD8BFC411A11FCC540FC2964A400431CC57B2916B5B388ADFF41002080"
	$string &= "F0DD1A06ABC36153A4DC0C885344600B0D61C7C3302035F860AB62DF31A0EECD6345C33F19306FB3443EAD4C0429F27F9118A8C89728C1A6B03F22350AC9E915"
	$string &= "3031A09EFF031B8787254A98DF61A51FAD4A0358EE06D95F8945BE9D14C300028805ADDE85450E6C2D39EC444A0106C42649E43A990769F007560D7033A0DE54"
	$string &= "FD07A9F86663C0BDC9011621B0C426C180D8CB464E40FE47AAF7616BED3F30103EA10C17802D7E814DC42842132933B48D019A847904C5B03607B54B83D548B9"
	$string &= "3B149A09C9CEFD200010402C580680F8A03946185A878A4313026C83026C8C801FA9FF8FBCD08105ADA8865D6186BCED1ADB7E38E486251703622F3D25F5F57F"
	$string &= "A43A9F0D6DBC80D49C0F7213681D02E89C00D094AC0A03EA1A7F903FF73140AED5032D237BC340BD23E1CF437B016D486214E77E1000082016A47A0D96F3F990"
	$string &= "2218B6A902763C0A2B03EA86034EB406E45FA4F102D86996B095BCE8D79CA0B7FA91DB001C68E6519200FE21E5602632120023528312B458331CCA7F8DD40361"
	$string &= "853674BDA176C0560653ABD7B1078A6120155A022183DDA4E67E10000820E4B17B16B4E15FD8BA3858B18FBC55095645B06319FA453E6411FD5E1BE49536C809"
	$string &= "07B9158FBCE48A1AADF5FF488D5C66321A7CCC50FF838A7D5BA89F5F3120EE0686990DABF7416A403B879E31907E2632B1005BEEEF22C720800062420B7416A4"
	$string &= "44817CF4181B5202408E7C981EF47DFCE877D6227797D00790D07B01C83B60A811F98C68238BA424AABF48C53FA8EE57471ADA461ECDFC87D408846D49E36740"
	$string &= "5D904A2D802BF7EF21C730800062422B7A9990220C7969136C40881329E2D1A78A910F20F8CD80794803039A3AF435FFFF91C6067E32606EDCA4241130602969"
	$string &= "48D10FDB13C080A7510A1B29859D978C7E22D8A0CBFD200010402C58C6DE6103263F91866D991950277BD00F53802516D8A40FFA902F23D200D33706D47D71E8"
	$string &= "8900A686910A81873C6A494E6F02B954FB8B36448DCF2E98DF99E890FBCF939BFB4100208090078290C7EF61033A1F91EABADF0CA83B767E23A57AE40918D899"
	$string &= "C1E86BD761A77F7C47EA8F635B540A53F785813A17413022D94FEAA214D888E50F06C4699D5C48034BC8A50A6CF49205DA46F84241179694DC3F9D1203010288"
	$string &= "05AD788415DDDFA08DBD2FD0BEF34706C445474C684539F22956B05203B6AFED1B1AFECA807A6B08B688858D19BC878E04B23010B8FC9040E43321552BE4CC0A"
	$string &= "C236AC82165C820E9EF4839AF38101F5B066D8393FB099B8EF548E7C6CB91FB4C57B3625860204100B96C8FF058D7C58FFFD33D2000A0752A0C02E8C408FD45F"
	$string &= "0C88AB4B60FBF0BE32A05E608C6F3A183676F00EDAF26663A06C2287990173110BA96D803FD05C7D06DA2576400AA37F4843E4AFA10DB2470CB8F726900B42A9"
	$string &= "D1EF47070001843C87FF07A92887EDFD87ED097C8F34D8018BFCAFD084F19B01F5D4CBBF48C3AEC825CA77A446E13F020900799DBB0252BB8494DC8BDC157D47"
	$string &= "867EF45200E4A75B503668878E1E34477243E540BB8741A77B5F832684EF541C09044D07BB621137C15302C0868A973340B68463050001C482368A078B2C66A4"
	$string &= "963F0C33200DFC7C6640DD078F1E79B0EAE0375209F09D843A11B6D7FF25D44E3106D4E3D8FF139900600DD777486D197222FF1792DB6F434B836BD0AE1E1B03"
	$string &= "E29048D8E119D4CEFD6538C4D3A0550EB6B9FF4EA8FC1B7C09002080D0DB007F90220D96FB612DD9DF0C888320615503AC91873CA7F01BCD8CAF0CA8275D10B3"
	$string &= "30F43F525710760EB1345271FE074F4260441ABD831D76F591017536915C00F3EF5706C4ED288C0CA8AB9FA8BDEE0057EE47EE027E402B094AA1910FEB25E004"
	$string &= "0001C482A3AF0C1BD840EE8AFD6440EC8FFFC9807A061F2B03E66109DF90EAFE8F488327C44602AC7BF91129D1492025C2DF587A12C88726B342F5BE84263E6A"
	$string &= "6C5261406A4B7C67405D2DCD40A3513F4322D4CC82560777A0890539C1DCC1A7112080D09784C1EA7E2E06CC7BEBB990068B90977D3130209669211FCB0AEB46"
	$string &= "C24EB9FE49620240CECDB0C30F60EB1545A08D31E47D07E8F7FDC0CED9FFC4807A79C2505B12668016A122D01E8120117A410D52377C0A000208DB9A40D8583F"
	$string &= "2BD25030F2FE78E45334FF21CD1BC0F4C0EAEF0F48ED044A8A46E40116D8FE031E06C4ED66B0E9E77F48550ECCDE6F1474FF063300358CD711281D4055941103"
	$string &= "8109228000424F002C4843BEE8F7E5208F14FE421AB6852518D8F2F13F4891F0156DD087D20840BEAC89152951A2AF49403E9CE9EF10CDF9848000B4E80FC511"
	$string &= "F94EF81A7F30001040C80900B9FE443EA1127D98F80F03EAC104B0AA820DAD0DF01DA927408B1B3D9177EE32A1B55F188671C4E36A241A424BDDD3D006E10762"
	$string &= "34030410AE9D41C88D3AE45934E4D3A7913769B0A08D2920AFFBA3C57630E46D608C58C446378110090002087D7328FAF430235AAB1CF9562FF43B74D16706FF"
	$string &= "33D06E2F20BE04310A48000001846D77302303EEADE1D872187AE4C312C6E84EE0210000020C009A1CDB0C9E25A8BE0000000049454E44AE426082"
	Return $string
EndFunc
