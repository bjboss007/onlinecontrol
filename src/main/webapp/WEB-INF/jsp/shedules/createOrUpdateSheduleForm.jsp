<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>

    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>

    <c:choose>
        <c:when test="${shedule['new']}">
            <c:set var="method" value="post"/>
            <spring:url value="/shedules/new" htmlEscape="true" var="action"/>
        </c:when>
        <c:otherwise>
            <c:set var="method" value="put"/>
            <spring:url value="/shedules/${shedule.id}/edit" htmlEscape="true" var="action"/>
        </c:otherwise>
    </c:choose>

    <jsp:include page="../fragments/jQueryLib.jsp"/>

    <jsp:include page="../fragments/datatablesLib.jsp"/>

    <script>

        function onAddRow(index) {
            var selectorTable = "#shedule" + index + " > tbody";
            $(selectorTable).append("<tr><td> cell </td></tr>");

        };

        function onDeleteRow(index) {
            alert(f);
        };

        function onSubmit(f) {
            //TODO: correct data
            f.submit();
        };


        $(function () {
            $("#startDate").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                dateFormat: 'dd.mm.yy',
                numberOfMonths: 3,
                onClose: function (selectedDate) {
                    $("#endDate").datepicker("option", "minDate", selectedDate);
                }
            });
            $("#endDate").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                dateFormat: 'dd.mm.yy',
                numberOfMonths: 3,
                onClose: function (selectedDate) {
                    $("#startDate").datepicker("option", "maxDate", selectedDate);
                }
            });
        });
    </script>

</head>
<body>

<div id="wrapper-login">

    <h1>Расписание</h1>

    <form:form method="${method}" action="${action}" enctype='application/json' onsubmit="onSubmit(this)">

        <div>
            <label for="startDate">Дата начала</label>
            <input type="text" id="startDate" name="startDate"/>
            <label for="endDate">Дата окончания</label>
            <input type="text" id="endDate" name="endDate"/>
        </div>

        <br>

        <div>
            <label>Класс</label>
            <select name="classSelect">
                <option value="0"><c:out value="------Select a class------"/></option>
                <c:forEach var="varclazz" items="${clazzes}">
                    <option value="${varclazz.id}"><c:out value="${varclazz.number} - ${varclazz.letter}"/></option>
                </c:forEach>
            </select>
        </div>

        <br>

        <div>
            <a id="addWeek" href='#'>Добавить неделю</a>
            <a id="deleteWeek" href='#'> / Удалить неделю</a>
        </div>

        <div class="week">

            <div>
                <c:forEach var="vardayOfWeek" items="${daysOfWeek}">
                    <div style="border: solid;width: 30%">

                        <div>
                            <label style="font-weight: bold">${vardayOfWeek.value}</label>
                            <input type="text" name="dayOfTheWeek1" value="${vardayOfWeek.key}" hidden>
                        </div>

                        <br>

                        <div>
                            <a id="addRow" href='#' onclick="onAddRow('_1_' + ${vardayOfWeek.key})">Добавить</a>
                            <a id="deleteRow" href='#' onclick="onDeleteRow('_1_' + ${vardayOfWeek.key})"> / Удалить</a>
                        </div>
                        <table id="shedule_1_${vardayOfWeek.key}" class="display" cellspacing="0" border="1" width="30%">
                            <thead>
                            <tr>
                                <th>Время урока</th>
                                <th>Предмет</th>
                                <th>Преподаватель</th>
                            </tr>
                            </thead>

                            <tbody>
                            <tr id="row">
                                <td>
                                    <select name="period1">
                                        <option value="0"><c:out value="-------Время урока------"/></option>
                                        <c:forEach var="varperiod" items="${periods}">
                                            <option value="${varperiod.id}"><c:out value="${varperiod}"/></option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select name="subject1">
                                        <option value="0"><c:out value="-------Предмет------"/></option>
                                        <c:forEach var="varsubject" items="${subjects}">
                                            <option value="${varsubject.id}"><c:out
                                                    value="${varsubject.name}"/></option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select name="teacher1">
                                        <option value="0"><c:out value="-------Преподаватель------"/></option>
                                        <c:forEach var="varteacher" items="${teachers}">
                                            <option value="${varteacher.id}"><c:out
                                                    value="${varteacher.lastName} ${varteacher.firstName} ${varteacher.middleName}"/></option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <br>
                </c:forEach>

            </div>

        </div>

        <br>

        <input id="submit" type="submit" value="Сохранить"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </form:form>

</div>

</body>
</html>
