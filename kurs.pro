domains

  id=integer 
  name=string%название
  year=integer%год выпуска
  engine=string%двигатель
  volume=string%объем
  valves = string%количество клапанов
  ecu = string%ЭБУ
  fuel = string%тип топлива
  hpw = integer%мощность в л.с.
  torque = integer%крутящий момент
  drive = string%привод
  price = real%цена
  odometer = real%пробег
  color = string%цвет
  body = string%кузов
  turbine = string%турбина
  transmission = string%кпп
  lsd = string%блокировка дифференциала
  frontsus = string%передняя подвеска
  rearsus = string%задняя
  
  file = out
  
database
  volvo(id,name,year,engine,volume,valves,ecu,fuel,hpw,torque,drive,price,odometer,color,body,turbine,transmission,lsd,frontsus,rearsus)
predicates
  menu%интерфейс программы
  open_base(string)%открытие и чтение базы
  case(char)%реализация switch-case
  print_base%вывод всей базы
  line_show(char)%предложение вывода определенной записи
  writeor(id)%вспомогательный для line_show
  print_line(id)%вывод строки базы
  read_line(name,year,engine,volume,valves,ecu,fuel,hpw,torque,drive,price,odometer,color,body,turbine,transmission,lsd,frontsus,rearsus)%чтение данных для строки
  
goal
  clearwindow,
  makewindow(1,112,7," Menu ",0,0,25,80),
  makewindow(2,112,7," Records ",0,0,25,80),
  makewindow(3,112,7," Add record ",0,0,25,80),
  makewindow(4,112,7," Deleting record ",0,0,25,80),
  makewindow(5,112,7," Editing record ",0,0,25,80),
  makewindow(6,112,7," Write table to File ",0,0,25,80),
  makewindow(7,112,7," Opening base ",0,0,25,80),
  shiftwindow(7),
  cursor(10, 25),
  write("Enter the name of base: "),
  readln(FileName),%чтение имени файла с записями базы
  open_base(FileName),%открытие и чтение записей
  menu,
  removewindow(2,0),
  removewindow(3,0),
  removewindow(4,0),
  removewindow(5,0),
  removewindow(6,0),
  removewindow(7,0),
  save(FileName),%сохранение в файл
  retractall(_).%удаление базы данных из программы
  
  
clauses
	open_base(FileName):-
		existfile(FileName),
		consult(FileName).%чтение из файла
	open_base(_).
  
	menu:-
		shiftwindow(1),%переключение на окно меню
		cursor(8,25),
		write("1 - Show volvo base"),
		cursor(9,25),
		write("2 - Enter new record"),
		cursor(10,25),
		write("3 - Delete record"),
		cursor(11,25),
		write("4 - Edit record"),
		cursor(12,25),
		write("5 - Write table at file"),
		cursor(13,25),
		write("0 - Exit"),
		cursor(14,25),
		write("go to: "),
		readchar(Item),
		clearwindow,
		case(Item).
    
	case('1'):-   %вывод базы на экран
		shiftwindow(2),%переключение на окно
		print_base,%вывод записей на экран
		write("type 'y' if you want to see the line for determined ID: "),nl,
		readchar(C),
		line_show(C),%если пользователю необходима определенная запись
		clearwindow,
		menu.
	

	case('2'):-   %добавление записи
		shiftwindow(3),%переключение на окно
		write("ID: "),readint(ID),
		read_line(Name,Year,Engine,Vol,Valves,ECU,Fuel,HPW,Torque,D,Price,KM,Color,Body,Turbo,AMT,LSD,Fsus,Rsus),%чтение данных для новой записи
		assertz(volvo(ID,Name,Year,Engine,Vol,Valves,ECU,Fuel,HPW,Torque,D,Price,KM,Color,Body,Turbo,AMT,LSD,Fsus,Rsus)),%добавление новой записи
		clearwindow,
		menu;
		clearwindow,
		menu.
    
	case('3'):-   %удаление записи 
		shiftwindow(4),%переключение на окно
		cursor(10, 25),
		write("Enter ID of volvo: "),
		readint(DelID),%ввод ID
		retract(volvo(DelID,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),%удаление записи
		cursor(11, 25),
		write("done "),
		readchar(_),
		clearwindow,
		menu;
		cursor(11,25),
		write("ID is wrong"),nl,
		readchar(_),
		clearwindow,
		menu.
        
	case('4'):-   %редактирование записи
		shiftwindow(5),%переключение на окно
		cursor(10, 25),
		write("Enter ID of volvo: "),
		readint(EditID),%ввод ID
		clearwindow,
		cursor(0, 25),
		write("For this ID we have a volvo: "),
		cursor(2, 0),
		print_line(EditID),%вывод записи с подходящим ID
		read_line(Name,Year,Engine,Vol,Valves,ECU,Fuel,HPW,Torque,D,Price,KM,Color,Body,Turbo,AMT,LSD,Fsus,Rsus),%ввод новых значений
		retract(volvo(EditID,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)),%удаление
		assertz(volvo(EditID,Name,Year,Engine,Vol,Valves,ECU,Fuel,HPW,Torque,D,Price,KM,Color,Body,Turbo,AMT,LSD,Fsus,Rsus)),%добавление
		clearwindow,
		menu;
		cursor(12,25),
		write("ID is wrong"),nl,
		readchar(_),
		clearwindow,
		menu.
	
	case('5'):- %вывод в файл для удобного копирования в табличный редактор
		shiftwindow(6),%переключение на окно
		cursor(10, 25),
		write("enter filename: "), readln(FileName),%ввод названия файла
		openwrite(out,FileName),!,%открытие файла
		writedevice(out),
		write("ID\tName\tYear\tEngine\tVolume\tValves\tECU\tFuel\tHPW\tTorque(Newton/meter)\tDrive\tPrice\tOdometer\tColor\tBody\tTurbine\tTransmission\tLS Differential\tFront Suspention\tRear Suspention"),nl,%запись заголовка таблицы
		print_base,%вывод всей базы
		closefile(out),%закрытие файла
		writedevice(screen),%устройство вывода - экран
		cursor(12, 30),
		write("done "),
		readchar(_),
		clearwindow,
		menu;
		clearwindow,
		menu.
        
	case('0').%завершение работы
	case(_):-
		menu.
	
	line_show('y'):-%в случае, если необходимо вывести определенную запись
		write("Type ID of the line: "),
		readint(ID),
		writeor(ID),
		write("Type 'y' if you want to see the line for determined ID: "),nl,
		readchar(C),
		line_show(C).
	line_show(_).%в случае, если такой надобности нет
       
	writeor(ID):-print_line(ID);write("wrong ID").%проверка на корректность ID
    
	print_base:-%вывод всех записей
		volvo(ID,Name,Year,Engine,Vol,Valves,ECU,Fuel,HPW,Torque,D,Price,KM,Color,Body,Turbo,AMT,LSD,Fsus,Rsus),
		write(ID,"\t",Name,"\t",Year,"\t",Engine,"\t",Vol,"\t",Valves,"\t",ECU,"\t",Fuel,"\t",HPW,"\t",Torque,"\t",D,"\t",Price,"\t",KM,"\t",Color,"\t",Body,"\t",Turbo,"\t",AMT,"\t",LSD,"\t",Fsus,"\t",Rsus,"\t"),nl,
		fail.
	print_base.
  
	print_line(ID):-%вывод одной записи
		volvo(ID,Name,Year,Engine,Vol,Valves,ECU,Fuel,HPW,Torque,D,Price,KM,Color,Body,Turbo,AMT,LSD,Fsus,Rsus),
		write(ID,"\t",Name,"\t",Year,"\t",Engine,"\t",Vol,"\t",Valves,"\t",ECU,"\t",Fuel,"\t",HPW,"\t",Torque,"\t",D,"\t",Price,"\t",KM,"\t",Color,"\t",Body,"\t",Turbo,"\t",AMT,"\t",LSD,"\t",Fsus,"\t",Rsus,"\t"),nl.
		
	read_line(Name,Year,Engine,Vol,Valves,ECU,Fuel,HPW,Torque,D,Price,KM,Color,Body,Turbo,AMT,LSD,Fsus,Rsus):-%ввод данных для записи
		write("Name: "),readln(Name),
		write("Year: "),readint(Year),
		write("Engine: "),readln(Engine),
		write("Volume: "),readln(Vol),
		write("Valves: "),readln(Valves),
		write("ECU: "),readln(ECU),
		write("Fuel: "),readln(Fuel),
		write("Horse Power: "),readint(HPW),
		write("Torque of engine: "),readint(Torque),
		write("Wheel Drive: "),readln(D),
		write("Price: "),readreal(Price),
		write("Kilometrage: "),readreal(KM),
		write("Color: "),readln(Color),
		write("Type of body: "),readln(Body),
		write("Turbine: "),readln(Turbo),
		write("Transmission: "),readln(AMT),
		write("Self-blocking differential: "),readln(LSD),
		write("Front suspention: "),readln(Fsus),
		write("Rear suspention: "),readln(Rsus).