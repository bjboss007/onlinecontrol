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
    <sec:authorize access="isAuthenticated()">
        <sec:authentication property="principal.userId" var="userId"/>
        <sec:authentication property="principal.login" var="login"/>
    </sec:authorize>
    <c:choose>
        <c:when test="${user['new']}">
            <c:set var="method" value="post"/>
            <spring:url value="/registration" htmlEscape="true" var="action"/>
        </c:when>
        <c:otherwise>
            <c:set var="method" value="put"/>
            <spring:url value="/users/${userId}/edit" htmlEscape="true" var="action"/>
        </c:otherwise>
    </c:choose>

    <jsp:include page="../fragments/jQueryLib.jsp"/>

    <style>
        body {
            font-size: 62.5%;
        }

        label, input {
            display: block;
        }

        input.text {
            margin-bottom: 12px;
            width: 95%;
            padding: .4em;
        }

        fieldset {
            padding: 0;
            border: 0;
            margin-top: 25px;
        }

        h1 {
            font-size: 1.2em;
            margin: .6em 0;
        }

        div#users-contain {
            width: 350px;
            margin: 20px 0;
        }

        div#users-contain table {
            margin: 1em 0;
            border-collapse: collapse;
            width: 100%;
        }

        div#users-contain table td, div#users-contain table th {
            border: 1px solid #eee;
            padding: .6em 10px;
            text-align: left;
        }

        .ui-dialog .ui-state-error {
            padding: .3em;
        }

        .validateTips {
            border: 1px solid transparent;
            padding: 0.3em;
        }
    </style>
    <script>
        $(function () {
            var dialog, form,
// From http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#e-mail-state-%28type=email%29
                    emailRegex = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/,
                    name = $("#name"),
                    email = $("#email"),
                    password = $("#password"),
                    allFields = $([]).add(name).add(email).add(password),
                    tips = $(".validateTips");

            function updateTips(t) {
                tips
                        .text(t)
                        .addClass("ui-state-highlight");
                setTimeout(function () {
                    tips.removeClass("ui-state-highlight", 1500);
                }, 500);
            }

            function checkLength(o, n, min, max) {
                if (o.val().length > max || o.val().length < min) {
                    o.addClass("ui-state-error");
                    updateTips("Length of " + n + " must be between " +
                    min + " and " + max + ".");
                    return false;
                } else {
                    return true;
                }
            }

            function checkRegexp(o, regexp, n) {
                if (!( regexp.test(o.val()) )) {
                    o.addClass("ui-state-error");
                    updateTips(n);
                    return false;
                } else {
                    return true;
                }
            }

            function addUser() {
                var valid = true;
                allFields.removeClass("ui-state-error");
                valid = valid && checkLength(name, "username", 3, 16);
                valid = valid && checkLength(email, "email", 6, 80);
                valid = valid && checkLength(password, "password", 5, 16);
                valid = valid && checkRegexp(name, /^[a-z]([0-9a-z_\s])+$/i, "Username may consist of a-z, 0-9, underscores, spaces and must begin with a letter.");
                valid = valid && checkRegexp(email, emailRegex, "eg. ui@jquery.com");
                valid = valid && checkRegexp(password, /^([0-9a-zA-Z])+$/, "Password field only allow : a-z 0-9");
                if (valid) {
                    $("#users tbody").append("<tr>" +
                    "<td>" + name.val() + "</td>" +
                    "<td>" + email.val() + "</td>" +
                    "<td>" + password.val() + "</td>" +
                    "</tr>");
                    dialog.dialog("close");
                }
                return valid;
            }

            dialog = $("#dialog-form").dialog({
                autoOpen: false,
                height: 300,
                width: 350,
                modal: true,
                buttons: {
                    "Create an account": addUser,
                    Cancel: function () {
                        dialog.dialog("close");
                    }
                },
                close: function () {
                    form[0].reset();
                    allFields.removeClass("ui-state-error");
                }
            });
            form = dialog.find("form").on("submit", function (event) {
                event.preventDefault();
                addUser();
            });
            $("#create-user").button().on("click", function () {
                dialog.dialog("open");
            });
        });
    </script>

</head>
<body>

<div id="wrapper-login">

    <h1>Register New User</h1>

    <form:form modelAttribute="user" method="${method}" action="${action}">
        <table class="horiz">
            <tr>
                <td><form:label path="login">Login:</form:label></td>
                <td><form:input path="login"/><form:errors path="login" cssStyle="color:red;" cssclass="error"/></td>
            </tr>

            <tr>
                <td><form:label path="firstName">First name:</form:label></td>
                <td><form:input path="firstName"/><form:errors path="firstName" cssStyle="color:red;"
                                                               cssclass="error"/></td>
            </tr>

            <tr>
                <td><form:label path="middleName">Middle name:</form:label></td>
                <td><form:input path="middleName"/><form:errors path="middleName" cssStyle="color:red;"
                                                                cssclass="error"/></td>
            </tr>

            <tr>
                <td><form:label path="lastName">Last name:</form:label></td>
                <td><form:input path="lastName"/><form:errors path="lastName" cssStyle="color:red;"
                                                              cssclass="error"/></td>
            </tr>

            <tr>
                <td><form:label path="password">Password:</form:label></td>
                <td><form:password path="password"/><form:errors path="password" cssStyle="color:red;"
                                                                 cssclass="error"/></td>
            </tr>

            <tr>
                <td><label path="roles" for="roles">Roles:</label></td>
                <td>
                    <form:select path="roles">
                        <c:forEach items="${roles}" var="role">
                            <form:option value="${role.roleId}">${role.name}</form:option>
                        </c:forEach>
                    </form:select>
                </td>
            </tr>
            <tr>
                <td><label for="students">Students:</label></td>
                <td>
                    <form:select path="students">
                        <c:forEach items="${students}" var="student">
                            <form:option
                                    value="${student.studentId}">${student.lastName} ${student.firstName} ${student.middleName}</form:option>
                        </c:forEach>
                    </form:select>
                </td>
            </tr>

        </table>

        <input type="submit" value="Save"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </form:form>

</div>

<div id="dialog-form" title="Create new user">
    <p class="validateTips">All form fields are required.</p>

    <form>
        <fieldset>
            <label for="name">Name</label>
            <input type="text" name="name" id="name" value="Jane Smith" class="text ui-widget-content ui-corner-all">
            <label for="email">Email</label>
            <input type="text" name="email" id="email" value="jane@smith.com"
                   class="text ui-widget-content ui-corner-all">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" value="xxxxxxx"
                   class="text ui-widget-content ui-corner-all">
            <!-- Allow form submission with keyboard without duplicating the dialog button -->
            <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
        </fieldset>
    </form>
</div>
<div id="users-contain" class="ui-widget">
    <h1>Existing Users:</h1>
    <table id="users" class="ui-widget ui-widget-content">
        <thead>
        <tr class="ui-widget-header ">
            <th>Name</th>
            <th>Email</th>
            <th>Password</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>John Doe</td>
            <td>john.doe@example.com</td>
            <td>johndoe1</td>
        </tr>
        </tbody>
    </table>
</div>
<button id="create-user">Create new user</button>

</body>
</html>
