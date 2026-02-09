<%-- 
    Document   : ListarCat
    Created on : 23/01/2026, 16:38:59
    Author     : rafaelacancio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="estilos.css" rel="stylesheet" type="text/css">
        <title>Listagem</title>
    </head>
    <body>
        <h1>Listagem de Categorias</h1>
                <table style="border: 1px solid black;">
                    <tr>
                        <th>Id</th>
                        <th>Categoria</th>
                    </tr>
                    <%
                        int num = 0;
                    try{
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(""
                        + "jdbc:mysql://localhost:3306/bd_8202", "root", "");
                        Statement stmt = conn.createStatement();
                        
                        ResultSet rs = stmt.executeQuery("SELECT * FROM tCategoria");
                        while(rs.next()){
                        %>
                        <tr>
                            <td><%= rs.getInt("Id") %></td>
                            <td><%= rs.getString("categoria") %></td>
                            <% num ++;%>
                        </tr>
                        <%
                            }
                            %>
                            <tr><th>Número de registo na BD</th>
                                <th><%= num %></th></tr>
                            <%
                                rs.close();
                                stmt.close();
                                conn.close();
                        }catch (Exception e){
                        out.println("An error ocurred: " + e.getMessage());
                        }
                        %>             
                </table>
                <a class="bt" href="index.htm" target="_self">Voltar ao menu</a>
    </body>
</html>
