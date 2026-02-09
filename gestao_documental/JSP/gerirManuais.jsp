<%-- 
    Document   : gerirManuais
    Created on : 26/01/2026, 16:23:06
    Author     : rafaelacancio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="estilos.css" rel="stylesheet" type="text/css">
        <title>Gerir manuais</title>
         <%
            if(request.getMethod().equals("POST")){
                String acao = request.getParameter("acao");
                Class.forName("com.mysql.cj.jdbc.Driver"); // driver atualizado
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bd_8202", "root", "");
                if (acao.equals("inserir")){
                    String nome = request.getParameter("nome");
                    String isbn = request.getParameter("isbn");
                    String descricao = request.getParameter("descricao");
                    String tamanho = request.getParameter("tamanho");
                    String foto = request.getParameter("foto");
                    String ficheiro = request.getParameter("ficheiro");
                    String idSubCat = request.getParameter("idSubCat");
                    String publico = request.getParameter("publico");
                    String autor = request.getParameter("autor");
                    String sql = "INSERT INTO tDocumento "
                    + "(nome, isbn, descricao, tamanho, foto, ficheiro, idSubcat, publico, autor) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

                    PreparedStatement statement = conn.prepareStatement(sql);
                    statement.setString(1, nome);
                    statement.setString(2, isbn);
                    statement.setString(3, descricao);
                    statement.setString(4, tamanho);
                    statement.setString(5, foto);
                    statement.setString(6, ficheiro);
                    statement.setInt(7, Integer.parseInt(idSubCat));  // INT
                    statement.setInt(8, Integer.parseInt(publico));    // INT
                    statement.setString(9, autor);

                    try {  // captura erro real
                        int rowsInserted = statement.executeUpdate();
                        if(rowsInserted > 0){
                            out.println("<h2>Registo inserido com sucesso.</h2>");
                        } else {
                            out.println("<h2>Erro na inserção.</h2>");
                        }
                    } catch(SQLException e){
                        out.println("<h2>Erro SQL:</h2>");
                        out.println(e.getMessage());
                        e.printStackTrace();
                    }

                    statement.close();
                }
                else{
                    String idParam = request.getParameter("id");
                    int id = Integer.parseInt(idParam);
                    String sql = "DELETE FROM tDocumento WHERE Id = ?";
                    PreparedStatement statement = conn.prepareStatement(sql);
                    statement.setInt(1, id);

                    int rowsDeleted = statement.executeUpdate();
                    if(rowsDeleted > 0){
                        out.println("<h2>Registo apagado com sucesso.</h2>");
                    } else {
                        out.println("<h2>Não existe nenhum registo com esse id.</h2>"+ id);
                    }
                    statement.close();
                }
                conn.close(); // fecha conexão
            }
        %>
    </head>
    <body>
       <h1>Gerir SubCategorias</h1>
        <table border="1">
            <tr>
                <th>Id</th>
                <th>Nome</th>
                <th>ISBN</th>
                <th>Descrição</th>
                <th>Tamanho</th>
                <th>Foto</th>
                <th>Ficheiro</th>
                <th>SubCategorias</th>
                <th>Público</th>
                <th>Autor</th>
                <th>Ação</th>
            </tr>
            <%
                int num  = 0;
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bd_8202", "root", "");
                Statement stm = conn.createStatement();
                        
                ResultSet rs = stm.executeQuery("Select * from tDocumento");
                while(rs.next()){
            %>
                        <tr>
                            <td><%= rs.getInt("Id") %></td>
                            <td><%= rs.getString("nome") %></td>
                            <td><%= rs.getString("isbn") %></td>
                            <td><%= rs.getString("descricao")%></td>
                            <td><%= rs.getString("tamanho")%></td>
                            <td><% out.println("<img width='100px' src='"+ rs.getString("foto")+"'>");%></td>
                            <td><% out.println("<a target='_self' href='" + rs.getString("ficheiro")+ "'>Download</a>"); %></td>
                            <td><%= rs.getInt("idSubCat")%></td>
                            <td><%
                                if (rs.getString("publico").equals("0"))
                                    out.println("publico");
                                else
                                    out.println("privado");
                            %></td>
                            <td><%= rs.getString("Autor")%></td>
                            <td>
                        <form method="post" action="gerirManuais.jsp">
                            <input type="hidden" name="acao" value="apagar">
                            <input type="hidden" value="<%= rs.getInt("id") %>" name="id">
                            <input type="submit" value="Apagar">                    
                        </form>
                            </td>
                        </tr>
                <% num++; 
                    }
                %>
        <tr>
            <th colspan="2">Número de registos na BD</th>
            <th><%= num %></th>
        </tr>
        </table>
        <%
            rs.close();
            stm.close();
            conn.close();
        %>

        <h3>Inserir Manual</h3>
<form method="post" action="gerirManuais.jsp">
    <input type="hidden" name="acao" value="inserir">

    Nome: <input type="text" name="nome" size="50" maxlength="50"><br>
    ISBN: <input type="text" name="isbn" size="20" maxlength="20"><br>
    Descrição: <br><textarea name="descricao" cols="80" rows="3"></textarea><br>
    Tamanho: <input type="text" name="tamanho" size="20"><br>
    Foto (URL): <br><textarea name="foto" cols="80" rows="3"></textarea><br>
    Ficheiro (URL): <br><textarea name="ficheiro" cols="80" rows="3"></textarea><br>

    Sub Categoria: 
    <select name="idSubCat">
        <%
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/bd_8202", "root", "");
            Statement stm2 = conn2.createStatement();
            ResultSet rs_subcat = stm2.executeQuery("SELECT id, Subcategoria FROM tSubcategoria");
            while(rs_subcat.next()){
        %>
            <option value="<%= rs_subcat.getInt("id") %>"><%= rs_subcat.getString("Subcategoria") %></option>
        <%
            }
            rs_subcat.close();
            stm2.close();
            conn2.close();
        %>
    </select><br>

    Público:
    <select name="publico">
        <option value="0">Sim</option>
        <option value="1">Não</option>
    </select><br>

    Autor:
    <select name="autor">
        <%
            Connection conn3 = DriverManager.getConnection("jdbc:mysql://localhost:3306/bd_8202", "root", "");
            Statement stm3 = conn3.createStatement();
            ResultSet rs_autor = stm3.executeQuery("SELECT id, nome FROM tAutor");
            while(rs_autor.next()){
        %>
            <option value="<%= rs_autor.getInt("id") %>"><%= rs_autor.getString("nome") %></option>
        <%
            }
            rs_autor.close();
            stm3.close();
            conn3.close();
        %>
    </select><br>

    <input type="submit" value="Inserir"><br><br>
</form>
    <a class="bt" href="index.htm" target="_self">Voltar ao menu</a>
    </body>
</html>

