import 'dart:convert';

String lineChartOption(
    {List<String> dates,
    List<int> confirmed,
    List<int> deaths,
    List<int> recovered}) {
  // return '''
  //       option = {
  //               xAxis: {
  //                       show: true,
  //                       type: 'category',
  //                       data: ${jsonEncode(dates)},
  //                       splitLine: {
  //                               show: false
  //                       }
  //               },
  //               yAxis: {
  //                       show: true,
  //                       type: 'value',
  //                       splitLine: {
  //                               show: false
  //                       },
  //               },
  //   grid: [{
  //       bottom: '10%'
  //   }, {
  //       top: '10%'
  //   }],
  //               series: [{
  //                       type: 'line',
  //                       smooth:true,
  //                       showSymbol: false,
  //                       hoverAnimation: true,
  //           areaStyle: {
  //                       smooth:true,
  //                        color: '#29056b'
  //                  },
  //                       lineStyle: {
  //                               width: 3,
  //                               color: '#29056b'
  //                       },
  //                       data: $confirmed
  //               },
  //               {
  //                       type: 'line',
  //                       smooth:true,
  //                       showSymbol: false,
  //                       hoverAnimation: true,
  //           areaStyle: {
  //                       smooth:true,
  //                               color: 'green'},
  //                       lineStyle: {
  //                               width: 3,
  //                               color: 'green'
  //                       },
  //                       data: $recovered
  //               },
  //               {
  //                       type: 'line',
  //                       smooth:true,
  //                       showSymbol: false,
  //                       hoverAnimation: true,
  //           areaStyle: {
  //                       smooth:true,
  //                               color: 'red'},
  //                       lineStyle: {
  //                               width: 3,
  //                               color: 'red'
  //                       },
  //                       data: $deaths
  //               },]
  //       }

  //       ''';
  return '''
 option = {
   xAxis: {
       type: 'category',
       data: ['21/01/2020', '22/01/2020', '23/01/2020']
   },
   yAxis: {
       type: 'value'
   },
   series: [{
       data: [820, 932, 901, 934, 1290, 1330, 1320],
       type: 'line'
   }]
 };                                                                                                                                                                                                              
 ''';
}
//,
//dataZoom: [{
//type: 'inside',
//start: 0,
//zoomLock: true
//}],
