// sort.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <iostream>

using namespace std;

void insert_sort(int a[], int len)
{
	//1.find pos 2.get in
	int watch,pos;
	for (int i = 1; i < len; i++)
	{
		watch=a[i];
		//1.find the pos,j is the pos 
		pos = 0;
		while (watch > a[pos])
		{
			pos++;
		}
		//2.get in(move the array [j,i),then get in) 
		for (int k = i-1; k >= pos; k--)
		{
			a[k + 1] = a[k];
		}
		a[pos] = watch;
		//this is debug
		for (int q = 0; q < len; q++)
			cout << a[q] <<' ';
		cout << endl;
	}
}

void half_sort(int a[], int len)
{
	int watch, j = 0, pos, low, high, mid;
	for (int i = 1; i < len; i++)
	{
		watch = a[i];
		low = 0;
		high = i - 1;
		//find the pos
		while (low <= high)
		{
			mid = (low + high / 2);
			if (a[mid] > watch)
				high = mid - 1;
			else
				low = mid + 1;
		}
		//high is the pos
		for (int k = i - 1; k >= high; k--)
		{
			a[k + 1] = a[k];
		}
		a[high + 1] = watch;
	}
}


void bub_sort(int a[], int len)
{
	for (int j=len-1;j>0;j--)
		for (int i = 0; i < j; i++)
		{
			if (a[i + 1] < a[i])
			swap(a[i + 1], a[i]);
		}
}
int * shellpass(int *sqList, int h, int len)
{
	int watch,pos;
	for (int i = 0; i < h; i++)
	{
		//插入排序
		for (int j = i; j < len; j += h)
		{
			//1.find pos
			watch=sqList[j];
			pos = i;
			while (watch > sqList[pos]) pos+=h;
			//2.get in 
			for (int k = j - 1; k >= pos; k--)
			{
				sqList[k + h] = sqList[k];
			}
			sqList[pos] = watch;		 
	    }
	}
	return sqList;
}

void shell_sort(int a[],int len,int h[],int hlen)
{
	int * temList = a;
	for (int i = hlen - 1; i >= 0; i--)
	{
		cout << h[i] << endl;
		temList = shellpass(temList, h[i], len);
		for (int q = 0; q < len; q++)
			cout << a[q] << ' ';
		cout << endl;
	}
}

void quick_sort(int a[], int low, int high)
{
	if (low >= high)
	{
		return;
	}
	int first = low;
	int last = high;
	int key = a[first];/*用字表的第一个记录作为枢轴*/
	while (first < last)
	{
		while (first < last && a[last] >= key)
		{
			--last;
		}
		a[first] = a[last];/*将比第一个小的移到低端*/
		while (first < last && a[first] <= key)
		{
			++first;
		}
		a[last] = a[first];
		/*将比第一个大的移到高端*/
	}
	a[first] = key;/*枢轴记录到位*/
	quick_sort(a, low, first - 1);
	quick_sort(a, first + 1, high);
}

void choose_sort(int a[], int len) {
	int min=1000,pos;
	for (int i = 0; i < len; i++)
	{
		//choose the min,record pos,
		for (int j = i; j < len; j++)
		{
			if (a[j] < min)
			{
				min = a[j];
				pos = j;
			}
		}
		//swap
		swap(a[pos], a[i]);
		min = 1000;	
	}
}
int main()
{
	int len,hlen;
	int a[] = {0,4,3,2,1,5,6,7,8,9};
	int h[] = { 1,3,6 };
	hlen = sizeof(h) / sizeof(h[0]);
	len = sizeof(a) / sizeof(a[0]);
	//bub_sort(a, len);
	//insert_sort(a, len);
	//half_sort(a, len);
	//shell_sort(a, len, h, hlen);
   //quick_sort(a, 0, len - 1);
	//choose_sort(a, len);
	//print array
	for (int i = 0; i < len; i++) {
		cout << a[i] << ' ';
	}
	system("pause");
    return 0;
}

