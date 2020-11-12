										---------------------------------------------------------------------------------------------------
--
-- Title       : CNetlist_Lib
-- Design      : Computer Netlist Engineering
-- Author      : Anatolij Sergyienko
-- Company     : NTUU "KPI"
---------------------------------------------------------------------------------------------------
-- File        : CNetlist_Lib.vhd
-- Generated   : Thu Sep 23 08:55:32 2004
---------------------------------------------------------------------------------------------------
-- Description : ?????????? ??????? ? ????????
--              ??? ?????????? ?????????? ???? ?? ?????? ??? ? ????
--              ???????? ???? - integer, bit ? bit_vector 
--				 Synopsys.BV_Arithmetic
---------------------------------------------------------------------------------------------------
Library IEEE;  
use	 IEEE.STD_LOGIC_1164.all;

Package CNetwork_lib is
	constant MINUS1: bit_vector(31 downto 0):=(31=>'1', others=>'0');
	subtype Z01 is STD_uLOGIC range '0'to'Z';-- '0' to 'Z'; 
	--?????????????? ??????? ??? - ????? ? ?????? ???? ? ?????
	function BIT_TO_INT(b:bit_vector) return integer;	   				 
	--BVtoI
	--?????????????? ??????? ??? - ????? ? ???.???? ? ?????
	function BITS_TO_INT(b:bit_vector) return integer;	   				 
	--SBVtoI
	--?????????????? ???? ? ?????
	function BIT_TO_INT(b:bit) return integer;	   				 
	
	--?????????????? ?????? ?? ?????? ? ?????? ??? - ????? ? ?????? ????
	function INT_TO_BIT(i,l:integer) return bit_vector;
	
	--?????????????? ?????? ?? ?????? ? ?????? ??? - ????? ? ???.????
	function INT_TO_BITS(i,l:integer) return bit_vector;
	--ItoBV
	--?????????????? ?????? 0|1 ? ???
	function INT_TO_BIT(i:integer) return bit;
	
	--?????????? ?????????? ?????????  ??????? 
	-- 	e,d,c,b,a - ???????? ????? ? ???????, ?- ??????? ???,
	-- mask-?????????? ???????, ????? ???- ?? ???????? ?????? 
	function LOG_TAB(e,d,c,b,a:BIT:='0';mask:bit_vector) return bit;	
	function LOG_TAB(e,d,c,b,a:STD_LOGIC:='0';mask:bit_vector) return STD_LOGIC;	
	
	
	
end CNetwork_lib;


Package body CNetwork_lib is	   	 
	
	function BIT_TO_INT(b:bit_vector) return integer is
		variable bi:bit_vector(b'range); 
		variable fl:boolean:=false;
		variable t,j:integer:=0;
	begin							   
		assert b'length<=32 report "??????? ??????? ?????? ???" severity failure;
		-- 	????????? ? ?????	
		for i in b'reverse_range loop
			if b(i)='1' then
				t:=t+2**j;
			end if;
			j:=j+1;
		end loop; 	
		return t;		
	end function;
	
	function BITS_TO_INT(b:bit_vector) return integer is
		variable bi:bit_vector(b'range); 
		variable fl:boolean:=false;
		variable t,j:integer:=0;
	begin							   
		assert b'length<=32   report "??????? ??????? ?????? ???" severity failure;
		bi:=b;
		--???????? ?????? ??? 
		if b(b'left)='1' then
			for i in b'reverse_range loop
				if not fl and b(i)='1' then
					fl:=true;
				elsif fl then	
					bi(i):=not b(i);
				end if;	
			end loop; 
		end if;
		-- ?	????????? ? ?????	
		for i in b'reverse_range loop
			if bi(i)='1' then
				t:=t+2**j;
			end if;
			j:=j+1;
		end loop; 	
		--? ???????????? ?? ??????
		if b(b'left)='1' then	 
			t:=-t;
		end if;	 
		return t;		
	end function;
	
	function BIT_TO_INT(b:bit) return integer is
	begin		  
		if b='0' then
			return 0;
		else
			return 1;
		end if;
	end function;
	
	function INT_TO_BIT(i,l:integer) return bit_vector is
		variable bv: bit_vector(l-1 downto 0):=(others=>'0');
		variable ii,i2:integer;	 
		variable fl:boolean:=false;
	begin	 
		assert l<=32 report "??????? ??????? ??????";
		ii:=i;
		--?????????? ??????? ?????
		for j in bv'reverse_range loop
			i2:=ii/2;
			if i2*2/=ii then
				bv(j):='1';
			end if;
			ii:=i2;				
		end loop;	
		return bv;
	end function;
	
	function INT_TO_BITS(i,l:integer) return bit_vector is
		variable bv: bit_vector(l-1 downto 0):=(others=>'0');
		variable ii,i2:integer;	 
		variable fl:boolean:=false;
	begin	 
		assert l<=32 report "??????? ??????? ??????";
		ii:=abs(i);
		--?????????? ??????? ?????
		for j in bv'reverse_range loop
			i2:=ii/2;
			if i2*2/=ii then
				bv(j):='1';
			end if;
			ii:=i2;				
		end loop;	
		--????????? ???.????
		if i<0 then
			for j in bv'reverse_range loop
				if not fl and bv(j)='1' then
					fl:=true;
				elsif fl then	
					bv(j):=not bv(j);
				end if;			
			end loop;
		end if;
		return bv;
	end function;
	
	function INT_TO_BIT(i:integer) return bit is
		
	begin
		assert i=0 or i=1 or i=integer'left report"??????????? ????? ??????" severity failure;
		if i=0 then
			return '0';
		else
			return '1';
		end if;
	end function;
	
	
	function LOG_TAB(e,d,c,b,a:BIT:='0';mask:bit_vector) return bit is
		variable adr: integer:=0;
		variable v:bit_vector(4 downto 0);	 
	begin	   						
		v:=e&d&c&b&a;
		for i in 0 to 4 loop
			if v(i)='1' then 
				adr:=adr+2**i ;
			end if;
		end loop;
		return mask(adr);
	end function ;	
	
	function LOG_TAB(e,d,c,b,a:STD_LOGIC:='0';mask:bit_vector) return STD_LOGIC is
		variable adr: integer:=0;
		variable v:std_logic_vector(4 downto 0);	 
	begin	   						
		v:=e&d&c&b&a;
		for i in 0 to 4 loop
			if v(i)='1' then 
				adr:=adr+2**i ;
			end if;
		end loop;
		return TO_STDULOGIC(mask(adr));
	end function ;
	
end package body;		   

Library IEEE;  
use	 IEEE.STD_LOGIC_1164.all;		
use Cnetwork_lib.all;  
entity LUT4 is	
	generic(init:bit_vector(15 downto 0):=X"ffff";
		td:time:=1 ns);
	port(
		I0: in STD_LOGIC;
		I1: in STD_LOGIC;
		I2: in STD_LOGIC;
		I3: in STD_LOGIC;
		O : out STD_LOGIC
		);
end LUT4;

architecture BEH of LUT4 is	 
begin	   
	O<=LOG_TAB('0',I3,I2,I1,I0,init) after td;	 
end BEH; 

Library IEEE;  
use	 IEEE.STD_LOGIC_1164.all;
use Cnetwork_lib.all;
entity LUT5 is
	generic(init:bit_vector(31 downto 0):=X"ffffffff";
		td:time:=1 ns);
	port(
		I0: in STD_LOGIC;
		I1: in STD_LOGIC;
		I2: in STD_LOGIC;
		I3: in STD_LOGIC;			   
		I4: in STD_LOGIC;
		O : out STD_LOGIC
		);
end LUT5;	

Library IEEE;  
use	 IEEE.STD_LOGIC_1164.all;
use Cnetwork_lib.all;  
entity LUT3 is	
	generic(init:bit_vector(7 downto 0):=X"ff";
		td:time:=1 ns);
	port(
		I0: in STD_LOGIC;
		I1: in STD_LOGIC;
		I2: in STD_LOGIC;
		--d : in STD_LOGIC;
		O : out STD_LOGIC
		);
end LUT3;

architecture BEH of LUT3 is	 
begin	  
	O<=LOG_TAB('0','0', I2,I1,I0,init) after td;	 
end BEH;

architecture BEH of LUT5 is	 
begin	   
	O<=LOG_TAB(I4,I3,I2,I1,I0,init) after td;	 
end BEH;	


-- ????????? ????????? ????? ? ??????????? ??????????????
Library IEEE;
Use IEEE.MATH_REAL.ALL;
use	 IEEE.STD_LOGIC_1164.all;  
use	 IEEE.STD_LOGIC_arith.all;
use Cnetwork_lib.all;
entity RANDOM_GEN is	  
	generic(n:positive:=8; --??????????? ????????? ?????
		tp:time:=100 ns	;		-- ?????? ??????????  
		SEED:positive:=12345   -- ????????? ?????????
		);		
	port(CLK:out STD_LOGIC;
		Y : out STD_LOGIC_vector(n-1 downto 0)
		);
end RANDOM_GEN; 				

architecture BEH of RANDOM_GEN is
begin	  
	process		  
		variable clki:STD_LOGIC;
		variable a,b:positive:=SEED;
		variable s:real;
	begin  
		Uniform(a,b,s);
		clki:=not clki;
		CLK<=clki;
		wait for tp/2;
		clki:=not clki;
		CLK<=clki;
		Y<=CONV_STD_LOGIC_VECTOR(integer(s*real(2**n)),n) ;
		wait for tp/2 ;
		
	end process;
	
end BEH;	

Library IEEE;
Use IEEE.MATH_REAL.ALL;
use	 IEEE.STD_LOGIC_1164.all;  
use	 IEEE.STD_LOGIC_arith.all;
use Cnetwork_lib.all;
entity RANDOM_BIT is	  
	generic(n:positive:=1; --??????????? ????????? ?????
		tp:time:=100 ns	;		-- ?????? ??????????  
		SEED:positive:=1   -- ????????? ?????????
		);		
	port(CLK:out STD_LOGIC;
		 Q: out STD_LOGIC
		);
end RANDOM_BIT; 				

architecture BEH of RANDOM_BIT is
begin	  
	process		  
		variable clki:STD_LOGIC;
		variable a,b:positive:=SEED;
		variable x:real;
	begin  
		Uniform(a,b,x);
		clki:=not clki;
		CLK<=clki;
		wait for tp/2;
		clki:=not clki;
		CLK<=clki;	
		if x > 0.5 then 
			Q <= '1';
		else 
			Q <= '0';
		end if;
		wait for tp/2 ;
		
	end process;
	
end BEH;
--??????? ? ??????????? ?????? CE ? ??????????? ??????? R	 
Library IEEE;  
use	 IEEE.STD_LOGIC_1164.all;
entity FDRE  is generic(td:time:=1 ns);
	port (Q:out  STD_LOGIC; 
		D :	in   STD_LOGIC;
		C :	in   STD_LOGIC;
		CE:	in   STD_LOGIC;
		R :	in   STD_LOGIC);
end FDRE;
architecture BEH of FDRE is	
	signal qi:STD_LOGIC;
begin
	process(C,R) begin
		if R='1' then
			qi<='0';
		elsif C='1' and C'event then
			if CE='1' then
				qi<=D;
			end if;
		end if;
	end process;
	Q<=qi after td;
end BEH;


