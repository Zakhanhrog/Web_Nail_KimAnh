package com.tiemnail.app.controller;

import com.tiemnail.app.dao.ExpenseDAO;
import com.tiemnail.app.dao.UserDAO; // Để lấy người ghi nhận (nếu cần)
import com.tiemnail.app.model.Expense;
import com.tiemnail.app.model.User; // Nếu bạn muốn gán người ghi nhận

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/expenses/*")
public class ExpenseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExpenseDAO expenseDAO;
    private UserDAO userDAO;

    public void init() {
        expenseDAO = new ExpenseDAO();
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/new":
                    showNewExpenseForm(request, response);
                    break;
                case "/insert":
                    insertExpense(request, response);
                    break;
                case "/delete":
                    deleteExpense(request, response);
                    break;
                case "/edit":
                    showEditExpenseForm(request, response);
                    break;
                case "/update":
                    updateExpense(request, response);
                    break;
                default: // "/list"
                    listExpenses(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException("Database error in ExpenseServlet: " + ex.getMessage(), ex);
        } catch (ParseException e) {
            throw new ServletException("Date parsing error in ExpenseServlet: " + e.getMessage(), e);
        }
    }

    private void loadUsersForForm(HttpServletRequest request) throws SQLException {
        // Lấy danh sách admin/staff/cashier có thể ghi nhận chi phí
        List<User> userList = userDAO.getUsersByRole("admin");
        userList.addAll(userDAO.getUsersByRole("staff"));
        userList.addAll(userDAO.getUsersByRole("cashier"));
        request.setAttribute("userList", userList);
    }


    private void listExpenses(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException, ParseException {
        List<Expense> listExpense;
        String filterStartDateStr = request.getParameter("filterStartDate");
        String filterEndDateStr = request.getParameter("filterEndDate");
        String filterCategory = request.getParameter("filterCategory");

        if (filterStartDateStr != null && !filterStartDateStr.isEmpty() && filterEndDateStr != null && !filterEndDateStr.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = new Date(sdf.parse(filterStartDateStr).getTime());
            Date endDate = new Date(sdf.parse(filterEndDateStr).getTime());
            listExpense = expenseDAO.getExpensesByDateRange(startDate, endDate);
        } else if (filterCategory != null && !filterCategory.isEmpty()) {
            listExpense = expenseDAO.getExpensesByCategory(filterCategory);
        }
        else {
            listExpense = expenseDAO.getAllExpenses();
        }

        request.setAttribute("listExpense", listExpense);
        request.setAttribute("userDAO", userDAO); // Để JSP lấy tên người ghi nhận
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/expense_list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewExpenseForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        loadUsersForForm(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/expense_form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditExpenseForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Expense existingExpense = expenseDAO.getExpenseById(id);
        if (existingExpense == null) {
            response.sendRedirect(request.getContextPath() + "/admin/expenses/list?error=notfound");
            return;
        }
        request.setAttribute("expense", existingExpense);
        loadUsersForForm(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/admin/expense_form.jsp");
        dispatcher.forward(request, response);
    }

    private Expense parseAndValidateExpenseData(HttpServletRequest request, Expense expenseToUpdate)
            throws ParseException, ServletException, IOException, SQLException {

        Expense expense = (expenseToUpdate == null) ? new Expense() : expenseToUpdate;

        String expenseDateStr = request.getParameter("expenseDate");
        String description = request.getParameter("description");
        String amountStr = request.getParameter("amount");
        String category = request.getParameter("category");
        String supplier = request.getParameter("supplier");
        // String receiptUrl = request.getParameter("receiptUrl"); // Sẽ xử lý upload file sau nếu cần
        String recordedByUserIdStr = request.getParameter("recordedByUserId");

        if (expenseDateStr == null || expenseDateStr.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                amountStr == null || amountStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Ngày chi phí, Mô tả và Số tiền là bắt buộc.");
            return null;
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        expense.setExpenseDate(new Date(dateFormat.parse(expenseDateStr).getTime()));
        expense.setDescription(description);

        try {
            BigDecimal amount = new BigDecimal(amountStr);
            if(amount.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("errorMessage", "Số tiền phải lớn hơn 0.");
                return null;
            }
            expense.setAmount(amount);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Số tiền không hợp lệ.");
            return null;
        }

        expense.setCategory(category);
        expense.setSupplier(supplier);
        // expense.setReceiptUrl(receiptUrl); // Tạm thời chưa có upload

        if (recordedByUserIdStr != null && !recordedByUserIdStr.isEmpty() && !recordedByUserIdStr.equals("0")) {
            expense.setRecordedByUserId(Integer.parseInt(recordedByUserIdStr));
        } else {
            // Lấy user đang đăng nhập (nếu đã có session) hoặc để trống
            // Tạm thời để trống nếu không chọn
            expense.setRecordedByUserId(null);
        }
        return expense;
    }


    private void insertExpense(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ParseException, ServletException {

        Expense newExpense = parseAndValidateExpenseData(request, null);
        if (newExpense == null) { // Lỗi validate
            loadUsersForForm(request);
            // Giữ lại các giá trị đã nhập
            request.setAttribute("expense", createDraftExpenseFromRequest(request));
            request.getRequestDispatcher("/WEB-INF/jsp/admin/expense_form.jsp").forward(request, response);
            return;
        }

        expenseDAO.addExpense(newExpense);
        response.sendRedirect(request.getContextPath() + "/admin/expenses/list");
    }

    private void updateExpense(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ParseException, ServletException {
        int id = Integer.parseInt(request.getParameter("expenseId"));
        Expense existingExpense = expenseDAO.getExpenseById(id);
        if (existingExpense == null) {
            response.sendRedirect(request.getContextPath() + "/admin/expenses/list?error=notfound_update");
            return;
        }

        Expense updatedExpense = parseAndValidateExpenseData(request, existingExpense);
        if (updatedExpense == null) { // Lỗi validate
            loadUsersForForm(request);
            request.setAttribute("expense", existingExpense); // Gửi lại expense cũ với ID
            request.getRequestDispatcher("/WEB-INF/jsp/admin/expense_form.jsp").forward(request, response);
            return;
        }
        updatedExpense.setExpenseId(id); // Đảm bảo ID đúng

        expenseDAO.updateExpense(updatedExpense);
        response.sendRedirect(request.getContextPath() + "/admin/expenses/list");
    }

    private void deleteExpense(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        expenseDAO.deleteExpense(id);
        response.sendRedirect(request.getContextPath() + "/admin/expenses/list");
    }

    // Helper để tạo đối tượng Expense nháp từ request để fill lại form khi có lỗi
    private Expense createDraftExpenseFromRequest(HttpServletRequest request) throws ParseException{
        Expense draft = new Expense();
        String expenseDateStr = request.getParameter("expenseDate");
        if(expenseDateStr != null && !expenseDateStr.isEmpty()){
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            draft.setExpenseDate(new Date(dateFormat.parse(expenseDateStr).getTime()));
        }
        draft.setDescription(request.getParameter("description"));
        try {
            if(request.getParameter("amount")!=null && !request.getParameter("amount").isEmpty())
                draft.setAmount(new BigDecimal(request.getParameter("amount")));
        } catch (NumberFormatException e) {/*bỏ qua*/}
        draft.setCategory(request.getParameter("category"));
        draft.setSupplier(request.getParameter("supplier"));
        String recordedByUserIdStr = request.getParameter("recordedByUserId");
        if (recordedByUserIdStr != null && !recordedByUserIdStr.isEmpty() && !recordedByUserIdStr.equals("0")) {
            draft.setRecordedByUserId(Integer.parseInt(recordedByUserIdStr));
        }
        return draft;
    }
}