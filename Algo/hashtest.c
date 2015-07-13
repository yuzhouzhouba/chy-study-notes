/* this is a hashtest of a name example*/
#define NAME_NO 30
#define HASH_LENGTH 50
#define M 50

typedef struct
{
	char *py;	//名字的拼音
	int k;		//拼音所对应的整数	
}NAME;

typedef struct 		//哈希表
{
	char *py;
	int k;
	int si;		//查找长度
}HASH

#endif

void InitNameList()
{
	char *f;
	int r,s0,i;
	NameList[0].py="chenghaoyang";
	NameList[1].py="zhouxingyu";
	NameList[2].py="chenyadong";
	NameList[3].py="lizhaoning";
	NameList[4].py="renjiaxi";
	NameList[5].py="feiji";
	NameList[6].py="huangjiayao";
	NameList[7].py="wuwenyi";
	NameList[8].py="chy";
	NameList[9].py="zxy"; 
	NameList[10].py="rejx";
	for(i=0;i<name)
	{
  	s0 = 0;
  	f=NameList[i].py;
  	for(r = 0;*(f+r)!='\0';r++)	//字符对应ASCLL码相加，结果作为关键字
  		s0=*(f+r)+s0;
		NameList[i].k=s0;
	}	
}

void CreatHashList()
{
	int i;
	for(i=0;i<HASH_LENGTH;i++)
	 {
		HashList[i].py="";
		HashList[i].k=0;
		HashList[i].si=0;
 	 }
	
	for(i=0;i<HASH_LENGTH;i++ )
	{ 
		int sum=0;
		int adr=(NameList[i].k)%M;	//哈希函数  
		int d=adr;
	if(HashList[adr].si==0)
		{
			HashList[adr].k=NameList[i].l;	//如果不冲突
			HashList[adr].py=NameList[i].py;
			HashList[adr].si=1;
		}
		else//冲突
		{
			do
			{
				d=(d+NameList[i]%10+1)%M;//伪随机探测再散列
				sum=sum+1;
			}while (HashList[d].k!=0);
			HashList[d].l=NameList[i].k;
			HashList[d].py=NameList[i].py;
			HashList[d].si=sum+1;
		}
}





void FindList()		//查找哈希表 
{
	char name[20]={0};
	int s0=0,r,sum=1,adr,d;
	printf("请输入名字的拼音:");
	scanf("%s",name);
	for(r=0;r<20;r++)	//求出姓名对应的关键字
		s0=s0+name[r];
	adr=s0%M;		//使用哈希函数
	d=adr;
	

	if(HashList[adr].k==s0)	//分三种情况进行判断
		printf("\n姓名:%s 关键字:%d 查找长度:1	",HashList[d].py,s0);
	else if(HashList[adr].k==0)
		printf("no this record!!");
	else
	{
		int g=0;
		do
		{
			d=(d+s0%10+1)%M
			sum=sum+1
 			if(HashList[d].k==0)
			{
				printf("no this record!!");
				g=1;
			}
			if(HashList[d].k==s0)
			{
				printf("\n姓名:%s 关键字:%d 查找长度:1 ",HashList[d].py,s0,sum);
				g=1;
			}
		}while(g==0)
	}


void Display()	//显示哈希表
{
	int i;
	float average=0;
	printf("\n地址\t关键字\t搜索长度\tH(key)\t姓名\n"); //显示格式
	for(i=0;i<50;i++)
	{
		printf("%d",i);
		printf("\t%d",HashList[i].k);
		printf("\t\t%d",HashList[i].si);
		printf("\t\t%d"HashList[i].k%30);
		printf("\t %s",HashList[i].py);
		printf("\n");
	}
	for(i=0;i<HASH_LENGTH;i++)
		average=average+HashList[i].si;
	average/=NAME_NO;
	pri
}	


void main()
{
	char ch1;
	InitNameList();
	CreatHashList();
	do
	{
		printf("D.显示哈希表\nF.超找\nQ.退出\n请选择:\n");
		cin>>ch1;
		switch(ch1);
		{
			case 'D':Display(); cout<<endl;break;
			case 'F':FindList(); cout<<endl;break;
			case 'Q':exit(0);
		}
		cout<<"come on !(y/n):";
		cin>>&ch1;
	}while(ch1='n');
}


	
