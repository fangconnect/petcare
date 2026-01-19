import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/network/api_client.dart';
import '../data/repository/config_repository.dart';
import '../data/repository/pet_repository.dart';
import '../data/models/models.dart';
import 'providers/auth_provider.dart';
import 'home_screen.dart';

/// Provider for ConfigRepository (duplicated here to avoid circular import)
final _configRepositoryProvider = Provider<ConfigRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ConfigRepository(dio);
});

/// FutureProvider to fetch all diseases (duplicated here to avoid circular import)
final _diseasesProvider = FutureProvider<List<Disease>>((ref) async {
  final repository = ref.watch(_configRepositoryProvider);
  return await repository.getAllDiseases();
});

/// Provider for PetRepository
final petRepositoryProvider = Provider<PetRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PetRepository(dio);
});

/// Provider for creating a pet
final createPetProvider = FutureProvider.family<Pet, CreatePetParams>((ref, params) async {
  final repository = ref.watch(petRepositoryProvider);
  return await repository.createPet(
    ownerId: params.ownerId,
    diseaseId: params.diseaseId,
    name: params.name,
    species: params.species,
    imageUrl: params.imageUrl,
    birthdate: params.birthdate,
    templateId: params.templateId,
  );
});

/// Parameters for creating a pet
class CreatePetParams {
  final String ownerId;
  final String diseaseId;
  final String name;
  final String? species;
  final String? imageUrl;
  final String? birthdate;
  final String? templateId;

  CreatePetParams({
    required this.ownerId,
    required this.diseaseId,
    required this.name,
    this.species,
    this.imageUrl,
    this.birthdate,
    this.templateId,
  });
}

class CreatePetScreen extends ConsumerStatefulWidget {
  const CreatePetScreen({super.key});

  @override
  ConsumerState<CreatePetScreen> createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends ConsumerState<CreatePetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Disease? _selectedDisease;
  DiseaseTemplate? _selectedTemplate;
  String _selectedSpecies = 'Cat';
  bool _isLoading = false;

  static const List<String> _speciesOptions = ['Cat', 'Dog', 'Rabbit', 'Bird', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDisease == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a disease'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get current user from auth
    final authState = ref.read(authProvider);
    String? userId;
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    }
    
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final params = CreatePetParams(
        ownerId: userId,
        diseaseId: _selectedDisease!.id,
        name: _nameController.text.trim(),
        species: _selectedSpecies,
        templateId: _selectedTemplate?.id,
      );

      // Create the pet
      final petAsync = ref.read(createPetProvider(params).future);
      await petAsync;

      // Invalidate pets provider to refresh the list on HomeScreen
      ref.invalidate(petsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet created!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating pet: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Import diseasesProvider from home_screen
    final diseasesAsync = ref.watch(_diseasesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Pet'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              
              // Pet Name TextField
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  hintText: 'Enter pet name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a pet name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 24),

              // Species Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: const InputDecoration(
                  labelText: 'Species',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _speciesOptions.map((species) {
                  return DropdownMenuItem(
                    value: species,
                    child: Text(species),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSpecies = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 24),

              // Disease Dropdown
              diseasesAsync.when(
                data: (diseases) {
                  if (diseases.isEmpty) {
                    return const Text('No diseases available');
                  }

                  return DropdownButtonFormField<Disease>(
                    value: _selectedDisease,
                    decoration: const InputDecoration(
                      labelText: 'Disease',
                      hintText: 'Select a disease',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.medical_services),
                    ),
                    items: diseases.map((disease) {
                      return DropdownMenuItem<Disease>(
                        value: disease,
                        child: Text(disease.name),
                      );
                    }).toList(),
                    onChanged: (Disease? disease) {
                      setState(() {
                        _selectedDisease = disease;
                        _selectedTemplate = null; // Reset template when disease changes
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a disease';
                      }
                      return null;
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stackTrace) => Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                          'Error loading diseases',
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(_diseasesProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Template Dropdown (only shown when disease is selected)
              if (_selectedDisease != null && _selectedDisease!.diseaseTemplates != null && _selectedDisease!.diseaseTemplates!.isNotEmpty)
                Builder(
                  builder: (context) {
                    final templates = _selectedDisease!.diseaseTemplates!;
                    
                    // Auto-select default template if not selected
                    if (_selectedTemplate == null && templates.isNotEmpty) {
                      final defaultTemplate = templates.firstWhere(
                        (t) => t.isDefault,
                        orElse: () => templates.first,
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _selectedTemplate = defaultTemplate;
                          });
                        }
                      });
                    }

                    return DropdownButtonFormField<DiseaseTemplate>(
                      value: _selectedTemplate,
                      decoration: const InputDecoration(
                        labelText: 'Template',
                        hintText: 'Select a tracking template',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.assignment),
                      ),
                      isExpanded: true,
                      items: templates.map((template) {
                        return DropdownMenuItem<DiseaseTemplate>(
                          value: template,
                          child: Text(
                            template.isDefault 
                              ? '${template.templateName} (Default)'
                              : template.templateName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (DiseaseTemplate? template) {
                        setState(() {
                          _selectedTemplate = template;
                        });
                      },
                    );
                  },
                ),
              
              // Show message if no templates available
              if (_selectedDisease != null && (_selectedDisease!.diseaseTemplates == null || _selectedDisease!.diseaseTemplates!.isEmpty))
                Card(
                  color: Colors.orange.shade50,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No templates available for this disease. Using default tracking.',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
