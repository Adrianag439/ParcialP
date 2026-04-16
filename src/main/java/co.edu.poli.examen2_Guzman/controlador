package co.edu.poli.examen2_Guzman.controlador;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import co.edu.poli.examen2_Guzman.modelo.Apartamento;
import co.edu.poli.examen2_Guzman.modelo.Casa;
import co.edu.poli.examen2_Guzman.modelo.Inmueble;
import co.edu.poli.examen2_Guzman.modelo.Propietario;
import co.edu.poli.examen2_Guzman.servicios.DAOInmueble;
import co.edu.poli.examen2_Guzman.servicios.DAOPropietario;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.DatePicker;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleGroup;

public class ControlFormCard {

    // ========== COMPONENTES DEL TAB CONSULTAR ==========
    @FXML
    private TextField txtNumeroBuscar;
    @FXML
    private Button btnBuscar;
    @FXML
    private TextArea txtResultado;

    // ========== COMPONENTES DEL TAB CREAR ==========
    @FXML
    private TextField txtNumero;
    @FXML
    private DatePicker dateFecha;
    @FXML
    private ComboBox<String> cmbEstado;
    @FXML
    private TextField txtIdProp;
    @FXML
    private TextField txtNombreProp;
    @FXML
    private RadioButton rbCasa;
    @FXML
    private RadioButton rbApartamento;
    @FXML
    private ToggleGroup tipoInmueble;
    @FXML
    private TextField txtExtra;
    @FXML
    private Button btnCrear;

    private DAOInmueble daoInmueble;
    private DAOPropietario daoPropietario;

    @FXML
    private void initialize() {
        daoInmueble = new DAOInmueble();
        daoPropietario = new DAOPropietario();

        // Configurar fecha actual
        dateFecha.setValue(LocalDate.now());
        
        // Configurar ComboBox de estado
        cmbEstado.getItems().addAll("DISPONIBLE", "ARRENDADO", "VENDIDO");
        cmbEstado.setValue("DISPONIBLE");
        
        // Configurar ToggleGroup
        rbCasa.setSelected(true);
        txtExtra.setPromptText("Número de pisos");
        
        // Cambiar prompt según selección
        rbCasa.setOnAction(e -> txtExtra.setPromptText("Número de pisos"));
        rbApartamento.setOnAction(e -> txtExtra.setPromptText("Número de piso"));
        
        // Validación de números
        txtNumeroBuscar.focusedProperty().addListener((obs, oldVal, newVal) -> {
            if (!newVal) validarSoloNumeros(txtNumeroBuscar);
        });
        
        txtNumero.focusedProperty().addListener((obs, oldVal, newVal) -> {
            if (!newVal) validarSoloNumeros(txtNumero);
        });
        
        txtExtra.focusedProperty().addListener((obs, oldVal, newVal) -> {
            if (!newVal) validarSoloNumeros(txtExtra);
        });
        
        txtIdProp.focusedProperty().addListener((obs, oldVal, newVal) -> {
            if (!newVal) validarSoloNumeros(txtIdProp);
        });
    }

    @FXML
    private void pressConsulta(ActionEvent event) {
        txtResultado.clear();
        
        if (txtNumeroBuscar.getText().isBlank()) {
            mostrarAlerta("Ingrese número de inmueble");
            return;
        }
        
        try {
            int numero = Integer.parseInt(txtNumeroBuscar.getText());
            Inmueble i = daoInmueble.readone(numero);
            
            if (i != null) {
                txtResultado.setText(i.toString());
            } else {
                mostrarAlerta("No existe el inmueble con número: " + numero);
            }
        } catch (NumberFormatException e) {
            mostrarAlerta("Ingrese un número válido");
        } catch (Exception e) {
            mostrarAlerta("Error: " + e.getMessage());
        }
    }

    @FXML
    private void pressCreacion(ActionEvent event) {
        // Validar campos
        if (txtNumero.getText().isBlank()) {
            mostrarAlerta("Ingrese el número del inmueble");
            return;
        }
        
        if (dateFecha.getValue() == null) {
            mostrarAlerta("Seleccione la fecha de compra");
            return;
        }
        
        if (cmbEstado.getValue() == null) {
            mostrarAlerta("Seleccione el estado del inmueble");
            return;
        }
        
        if (txtIdProp.getText().isBlank()) {
            mostrarAlerta("Ingrese el ID del propietario");
            return;
        }
        
        if (txtNombreProp.getText().isBlank()) {
            mostrarAlerta("Ingrese el nombre del propietario");
            return;
        }
        
        if (txtExtra.getText().isBlank()) {
            mostrarAlerta("Ingrese el valor para " + txtExtra.getPromptText());
            return;
        }
        
        try {
            int numero = Integer.parseInt(txtNumero.getText());
            int idPropietario = Integer.parseInt(txtIdProp.getText());
            String nombrePropietario = txtNombreProp.getText();
            
            // FORMATO CORRECTO PARA MySQL (yyyy-MM-dd)
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            String fechaCompra = dateFecha.getValue().format(formatter);
            
            String estado = cmbEstado.getValue();
            
            // Crear propietario
            Propietario propietario = new Propietario(idPropietario, nombrePropietario);
            
            // Crear inmueble según tipo
            Inmueble nuevo;
            int extra = Integer.parseInt(txtExtra.getText());
            
            if (rbCasa.isSelected()) {
                nuevo = new Casa(numero, fechaCompra, estado, propietario, extra);
            } else {
                nuevo = new Apartamento(numero, fechaCompra, estado, propietario, extra);
            }
            
            String resultado = daoInmueble.create(nuevo);
            mostrarAlerta(resultado);
            
            if (resultado.startsWith("✔")) {
                limpiarFormulario();
            }
            
        } catch (NumberFormatException e) {
            mostrarAlerta("Los campos numéricos deben contener solo números");
        } catch (Exception e) {
            e.printStackTrace();
            mostrarAlerta("Error al crear: " + e.getMessage());
        }
    }
    
    private void limpiarFormulario() {
        txtNumero.clear();
        dateFecha.setValue(LocalDate.now());
        cmbEstado.setValue("DISPONIBLE");
        txtIdProp.clear();
        txtNombreProp.clear();
        txtExtra.clear();
        rbCasa.setSelected(true);
        txtExtra.setPromptText("Número de pisos");
    }

    private void mostrarAlerta(String mensaje) {
        Alert alert = new Alert(AlertType.INFORMATION);
        alert.setTitle("Sistema de Inmuebles");
        alert.setHeaderText(null);
        alert.setContentText(mensaje);
        alert.showAndWait();
    }

    private void validarSoloNumeros(TextField txt) {
        String texto = txt.getText().trim();
        if (!texto.isEmpty() && !texto.matches("\\d+")) {
            txt.setStyle("-fx-border-color: red;");
            mostrarAlerta("Solo se permiten números");
            txt.setText("");
            txt.requestFocus();
        } else {
            txt.setStyle("");
        }
    }
}
