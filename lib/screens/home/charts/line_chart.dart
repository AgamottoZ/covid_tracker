import 'dart:convert';

String lineChartOption(
    {List<String> dates,
    List<int> confirmed,
    List<int> deaths,
    List<int> recovered}) {
        return '''
        option = {
        dataZoom: [
{
            type: 'inside',
            start: 50,
            end: 100
        },
        {
            show: true,
            type: 'slider',
            top: '90%',
            handleIcon: 'M10.7,11.9H9.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4h1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
        }
    ],
                xAxis: {
                        show: true,
                        type: 'category',
                        data: ${jsonEncode(dates)},
                        splitLine: {
                                show: false
                        }
                },
                yAxis: {
                        show: true,
                        type: 'value',
                        splitLine: {
                                show: false
                        },
                },
    grid: [{
        bottom: '10%'
    }, {
        top: '10%'
    }],
                series: [{
                        type: 'line',
                        smooth:true,
                        showSymbol: false,
                        hoverAnimation: true,
            areaStyle: {
                        smooth:true,
                         color: '#29056b'
                   },
                        lineStyle: {
                                width: 3,
                                color: '#29056b'
                        },
                        data: $confirmed
                },
                {
                        type: 'line',
                        smooth:true,
                        showSymbol: false,
                        hoverAnimation: true,
            areaStyle: {
                        smooth:true,
                                color: 'green'},
                        lineStyle: {
                                width: 3,
                                color: 'green'
                        },
                        data: $recovered
                },
                {
                        type: 'line',
                        smooth:true,
                        showSymbol: false,
                        hoverAnimation: true,
            areaStyle: {
                        smooth:true,
                                color: 'red'},
                        lineStyle: {
                                width: 3,
                                color: 'red'
                        },
                        data: $deaths
                },]
        }

        ''';
//  return '''
//  option = {
//    xAxis: {
//        type: 'category',
//        data: ['21/01/2020', '22/01/2020', '23/01/2020']
//    },
//    yAxis: {
//        type: 'value'
//    },
//    series: [{
//        data: [820, 932, 901, 934, 1290, 1330, 1320],
//        type: 'line'
//    }]
//  };
//  ''';
}
//,
//dataZoom: [{
//type: 'inside',
//start: 0,
//zoomLock: true
//}],
