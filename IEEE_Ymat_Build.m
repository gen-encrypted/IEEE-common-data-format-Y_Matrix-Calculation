%'IEEEdata.txt'

function Y_matrix = IEEE_Ymat_Build

f_name=input('Enter file name'); % Reading filename from user
fid=fopen(f_name,'r'); % openning file  

tic % timer start
datacomplete= true; % indicator for loop 

while(datacomplete) % loop for reading branch and bus datas
    
lin = fgetl(fid); % reads line 
[non,linlength]= size(lin); % takes size of line 


if(strcmp(lin(1:3),'BUS')) % looks for bus data start
    while(1) % loops through bus data until "-999" comes
    lin = fgetl(fid); % reads line
    if(strcmp(lin(1:4),'-999')) 
      break;  % ends reading bus data
    end
    bus=str2num(lin(1:4)); % converting string to numerical variable
    B_conductance = str2num(lin(107:114)); % takes conductance data
    B_admitance =  str2num(lin(115:122)) ; % takes suseptance data
    Y_matrix(bus,bus)= B_conductance +i*B_admitance;  % adds taken data and assigns to Y matrix's nn element
    end
else if(strcmp(lin(1:6),'BRANCH')) % looks for branch data start
        while (1) % loops through bus data until "-999" comes
            lin= fgetl(fid); % reads line  
            if(strcmp(lin(1:4),'-999')) 
               
                datacomplete= false; % boolean is set to close the loop 
              break;  
            end

                bus_n1=str2num(lin(1:4)); % takes starting bus
                bus_n2=str2num(lin(6:9)); % takes ending bus 

                Resistance = (str2num(lin(20:29))); % takes resistance of branch 
                Inductance = i*(str2num(lin(30:40))); % takes Inductance value of line  
                shunt_admitance=i*(str2num(lin(41:50))); % takes Admitance value of the line 
                
                Y_matrix(bus_n1,bus_n2)= -1*((1/(Inductance + Resistance))); % calculates suseptance and assigns it to y matrix
                Y_matrix(bus_n1,bus_n1)=Y_matrix(bus_n1,bus_n1)+(shunt_admitance/2)-Y_matrix(bus_n1,bus_n2);
                Y_matrix(bus_n2,bus_n1)= -1*((1/(Inductance + Resistance))); % calculates suseptance and assigns it to y matrix but in a reversed manner
                Y_matrix(bus_n2,bus_n2)=Y_matrix(bus_n2,bus_n2)+(shunt_admitance/2)-Y_matrix(bus_n2,bus_n1);
        end
       
    end
  end

end
fclose(fid); % closes file
toc % ends timer
 for n=1:bus
     for j=1:bus
         if (Y_matrix(n,j)~=0)
       disp([num2str(n),' to ',num2str(j) ,' = ',num2str((Y_matrix(n,j)))])  
         end
     end
 end

end % returns a Y matrix as a result


